require "pathname"
require "yaml"

class TranslatedFile
  attr_reader :path, :project, :category, :topic

  def initialize(path)
    @path = Pathname.new(path)
    @front_matter = parse_front_matter
    @project, @category, @topic = parse_metadata
  end

  def content
    path.read
  end

  def front_matter
    parse_front_matter
  end

  def update_commit_hash(new_commit)
    return if new_commit == front_matter[:commit]
    updated_content = content.sub(/(commit:\s*")[^"]+(")/, "\\1#{new_commit}\\2")
    path.write(updated_content)
  end

  private

  FRONT_MATTER_REGEXP = /\A---\s*\n(.*?)\n---\s*\n/m

  def parse_front_matter
    front_matter_section = content.match(FRONT_MATTER_REGEXP)[0]
    if front_matter_section
      YAML.safe_load(front_matter_section, symbolize_names: true)
    else
      {}
    end
  end

  def parse_metadata
    # hotwire_ja/turbo/handbook/introduction.md
    # -> turbo, handbook, introduction.md
    project, category, filename = path.to_s.split("/").last(3)
    topic = filename.sub(".md", "")
    [project, category, topic]
  end
end
