require "json"
require "rake"

class TranslationPr
  include Rake::FileUtilsExt

  def initialize(repository_path, translated_file, diff_content, source_latest_commit)
    @repository_path = repository_path
    @translated_file = translated_file
    @diff_content = diff_content
    @source_latest_commit = source_latest_commit
  end

  def create_or_update
    current_title, current_description = find_existed_pr
    Dir.chdir(repository_path) do
      if current_title && current_description
        update_pr(branch,
                  update_description(current_description, diff_content),
                  source_latest_commit)
      else
        create_pr(branch,
                  title,
                  generate_description(diff_content),
                  source_latest_commit)
      end
    end
  end

  private

  attr_reader :translated_file, :repository_path, :diff_content, :source_latest_commit

  DIFF_START = "## Diff (Please don't change this section. It will be automatically updated.)"
  DIFF_END = "<!-- Please write your description under here. -->"

  def repo
    "#{owner}/#{repository}"
  end

  def owner
    ENV["TRANSLATED_OWNER"] || "everyleaf"
  end

  def repository
    ENV["TRANSLATED_REPOSIOTRY"] || "hotwire_ja"
  end

  def branch
    "update-translation-" +
      "#{translated_file.project}-" +
      "#{translated_file.category}-" +
      "#{translated_file.topic}"
  end

  def title
    "#{translated_file.project} " +
      "#{translated_file.category} " +
      "#{translated_file.topic}: " +
      "updated translation"
  end

  # Use '~~~' because commit diff might include '```'.
  def generate_description(diff)
<<-DESCRIPTION
#{DIFF_START}

~~~diff
#{diff}
~~~

#{DIFF_END}

DESCRIPTION
  end

  def update_description(description, diff)
    lines = description.lines
    diff_start = lines.index { |line| line.strip == DIFF_START }
    diff_end = lines.index { |line| line.strip == DIFF_END }

    if diff_start && diff_end && diff_start < diff_end
      before_diffs = lines[0...diff_start].join
      after_diffs = lines[(diff_end).next..-1].join

      before_diffs + generate_description(diff) + after_diffs
    else
      generate_description(diff)
    end
  end

  def find_existed_pr
    pr_raw_info = Tempfile.open("pr.json") do |pr|
      begin
        sh("gh",
          "pr",
          "view",
          branch,
          "--json", "closed,title,body",
          "--repo", repo,
          {out: pr}
        )
        pr.open.read
      rescue RuntimeError
        # When existed pr doesn't exist, gh command raises RuntimeError.
        ""
      end
    end
    if pr_raw_info.empty?
      [nil, nil]
    else
      pr_info = JSON.parse(pr_raw_info, symbolize_names: true)
      # Closed PR could be referenced by `gh pr view` command if there is no
      # open PR which has the same branch name.
      return [nil, nil] if pr_info[:closed]
      [pr_info[:title], pr_info[:body]]
    end
  end

  def commit_latest_hash(source_latest_commit)
    translated_file.update_commit_hash(source_latest_commit)
    sh("git", "add", translated_file.path.to_s)
    sh("git",
       "commit",
       "-m",
       "updated translation target commit")
  end

  def update_pr(branch, description, source_latest_commit)
    sh("git", "fetch")
    sh("git", "switch", "-c", branch, "origin/#{branch}")
    commit_latest_hash(source_latest_commit)
    sh("git", "push", "origin", branch)
    sh("gh",
       "pr",
       "edit",
       "--body", description,
       "--repo", repo)
  end

  def create_pr(branch, title, description, source_latest_commit)
    sh("git", "switch", "-c", branch)
    commit_latest_hash(source_latest_commit)
    sh("git", "push", "origin", branch)
    sh("gh",
       "pr",
       "create",
       "--title", title,
       "--body", description,
       "--base", "auto-translations-update",
       "--head", branch,
       "--repo", repo)
  end
end
