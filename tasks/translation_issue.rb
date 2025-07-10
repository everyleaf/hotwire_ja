require "json"
require "tempfile"
require "rake"

class TranslationIssue
  include Rake::FileUtilsExt

  attr_accessor :number, :title, :body

  def initialize(repository_path, translated_file, diff_content, source_latest_commit)
    @repository_path = repository_path
    @translated_file = translated_file
    @diff_content = diff_content
    @source_latest_commit = source_latest_commit
  end

  def create_or_update
    if find_existing_issue
      puts "Updating issue ##{number} for #{translated_file.path}"
      update_issue(number, generate_issue_body)
    else
      puts "Creating new issue for #{translated_file.path}"
      create_issue(issue_title, generate_issue_body)
    end
  end

  private

  attr_reader :translated_file, :repository_path, :diff_content, :source_latest_commit

  def repo
    "#{owner}/#{repository}"
  end

  def owner
    ENV["TRANSLATED_OWNER"] || "everyleaf"
  end

  def repository
    ENV["TRANSLATED_REPOSITORY"] || "hotwire_ja"
  end

  def issue_title
    "translation update: #{translated_file.project} #{translated_file.category} #{translated_file.topic}"
  end

  def issue_label
    "差分翻訳"
  end

  def metadata_tag
    "<!-- update-target: #{translated_file.project}/#{translated_file.category}/#{translated_file.topic} -->"
  end

  def find_existing_issue
    issues_json = Tempfile.open("issues.json") do |tmpfile|
      begin
        sh("gh", "issue", "list",
           "--repo", repo,
           "--state", "open",
           "--label", issue_label,
           "--search", issue_title,
           "--json", "number,title,body",
           { out: tmpfile, err: :close })
        tmpfile.open.read
      rescue RuntimeError => e
        # No matching issues found or gh command failed
        puts "Failed to search issues: #{e.message}"
      end
    end

    issues = JSON.parse(issues_json, symbolize_names: true)
    matching_issue = issues.find do |issue|
      issue[:body].include?(metadata_tag)
    end

    return if !matching_issue
    @number = matching_issue[:number]
    @title = matching_issue[:title]
    @body = matching_issue[:body]
    self
  end

  def create_issue(issue_title, issue_body)
    Tempfile.open("issue_body.md") do |tmpfile|
      tmpfile.write(issue_body)
      tmpfile.flush

      sh("gh", "issue", "create",
         "--repo", repo,
         "--title", issue_title,
         "--body-file", tmpfile.path,
         "--label", issue_label)
    end
  end

  def update_issue(issue_number, issue_body)
    Tempfile.open("issue_body.md") do |tmpfile|
      tmpfile.write(issue_body)
      tmpfile.flush

      sh("gh", "issue", "edit", issue_number.to_s,
         "--repo", repo,
         "--body-file", tmpfile.path)
    end
  end

  def generate_issue_body
    relative_path = translated_file.path.relative_path_from(repository_path)

    <<~BODY
      ## Translation Update Required

      The upstream documentation has been updated. Please review the changes and update the translation accordingly.

      **File**: `#{relative_path}`
      **Current translated commit**: `#{translated_file.front_matter[:commit]}`
      **Latest upstream commit**: `#{source_latest_commit}`

      ## Diff

      <details>
      <summary>Click to expand diff</summary>

      ~~~diff
      #{diff_content}
      ~~~

      </details>

      ## How to Update

      1. Fork this repository
      2. Update the translation in `#{relative_path}`
      3. Update the `commit` field in the front matter to `#{source_latest_commit}`
      4. Create a Pull Request with your changes

      [View changes on GitHub](#{github_compare_url})

      ---

      #{metadata_tag}
    BODY
  end

  def github_compare_url
    base_url = "https://github.com/hotwired/turbo-site/compare/"
    "#{base_url}#{translated_file.front_matter[:commit]}...#{source_latest_commit}"
  end
end
