require "pathname"

class SourceFile
  attr_reader :path

  def initialize(path)
    @path = Pathname.new(path)
  end

  def normalized_path
    # turbo-site/_source/{handbook|reference}/01_introduction.md
    # -> turbo-site/_source/{handbook|reference}/introduction.md
    normalized_basename = path.basename.sub(/^\d+_/, "")
    path.dirname + normalized_basename
  end

  def find_translated_file(files)
    # turbo-site/_source/handbook/introduction.md
    # -> handbook, introduction.md
    dir, basename = normalized_path.to_s.split("/").last(2)
    files.find do |file|
      file.path.to_s.match?(/\/#{dir}\/#{basename}\z/)
    end
  end
end
