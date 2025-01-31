require "pathname"

class SourceFile
  attr_reader :path

  def initialize(path)
    @path = Pathname.new(path)
  end

  def normalized_path
    normalized_basename = path.basename.sub(/^\d+_/, "")
    path.dirname + normalized_basename
  end

  def find_translated_file(files)
    dir, basename = normalized_path.to_s.split("/").last(2)
    files.find do |file|
      file.path.to_s.match?(/\/#{dir}\/#{basename}\z/)
    end
  end
end
