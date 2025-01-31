require "pathname"
require "yaml"

class TranslatedFile
  attr_reader :path, :front_matter

  def initialize(path)
    @path = Pathname.new(path)
    @front_matter = parse_front_matter
  end

  private

  FRONT_MATTER_REGEXP = /\A---\s*\n(.*?)\n---\s*\n/m

  def parse_front_matter
    content = path.read
    front_matter_section = content.match(FRONT_MATTER_REGEXP)[0]
    if front_matter_section
      YAML.safe_load(front_matter_section, symbolize_names: true)
    else
      {}
    end
  end
end
