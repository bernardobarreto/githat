require File.dirname(__FILE__) + '/parser'

class Diff
  def initialize
    @files = files_infos
  end

  def files_infos
    files = []
    files_names.map do |name|
      files << { name: name, diff: file_diff(name) }
    end
    files
  end

  def file_diff(file)
    `git diff #{file}`
  end

  def files_names
    `git diff --name-only`.split /\n/
  end
end

