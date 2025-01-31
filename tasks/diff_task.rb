require "pathname"
require_relative "translated_file"
require_relative "source_file"

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
          pp translated_file
        end
      end
    end
  end

  private

  def collect_source_files
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
