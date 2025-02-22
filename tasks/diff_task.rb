require "pathname"
require "tempfile"

require_relative "source_file"
require_relative "translated_file"
require_relative "translation_pr"

class DiffTask
  include Rake::DSL

  HANDBOOK_DIR = "handbook"
  REFERENCE_DIR = "reference"
  SOURCE_DIR = "_source"
  TURBO_DIR = "turbo"

  def define
    namespace :translate do
      desc "Show translation diff"
      task :diff do
        source_files = collect_source_files
        translated_files = collect_translated_files

        source_files.each do |source_file|
          translated_file = source_file.find_translated_file(translated_files)
          next unless translated_file

          source_latest_commit, diff_content = diff(source_file, translated_file)
          next unless diff_content

          translation_pr = TranslationPr.new(translation_repository_path,
                                             translated_file,
                                             diff_content,
                                             source_latest_commit)
          translation_pr.create_or_update
        end
      end
    end
  end

  private

  def diff(source_file, translated_file)
    translated_commit = translated_file.front_matter[:commit]
    return unless translated_commit
    return if translated_commit == source_latest_commit

    Tempfile.open("diff.txt") do |tempfile|
      sh("git",
         "-C",
         source_repository_path.to_s,
         "diff",
         "#{translated_commit}..#{source_latest_commit}",
         source_file.path.to_s,
         {out: tempfile})
      [source_latest_commit, tempfile.open.read]
    end
  end

  def source_latest_commit
    @source_latest_commit ||= Tempfile.open("latest_commit.txt") do |tempfile|
      sh("git",
        "-C",
        source_repository_path.to_s,
        "rev-parse",
        "--short",
        "main",
        {out: tempfile})
      tempfile.open.read.strip
    end
  end

  def collect_source_files
    # e.g. turbo-site/_source/{handbook|reference}/01_introduction.md
    [HANDBOOK_DIR, REFERENCE_DIR].flat_map do |dir|
      Pathname.glob(source_repository_path.join(SOURCE_DIR, dir, "*.md")).map do |source_path|
        SourceFile.new(source_path)
      end
    end
  end

  def source_repository_path
    path = Pathname(turbo_site_repository)
    path.expand_path
  end

  def collect_translated_files
    # e.g. hotwire_ja/turbo/{handbook|reference}/introduction.md
    [HANDBOOK_DIR, REFERENCE_DIR].flat_map do |dir|
      Pathname.glob(translation_repository_path.join(TURBO_DIR, dir, "*.md")).map do |translated_path|
        TranslatedFile.new(translated_path)
      end
    end
  end

  def translation_repository_path
    Pathname(__dir__).parent.expand_path
  end

  def turbo_site_repository
    repository = ENV["TURBO_SITE_REPOSITORY"]
    raise "Specify TURBO_SITE_REPOSITORY environment variable" if repository.nil?
    repository
  end
end
