require File.dirname(__FILE__) + '/parser'

class Diff
  def initialize
    @files = files_info
  end

  def files_info
    files = []
    files_name.map do |name|
      files << { name: name, diff: file_diff(name) }
    end
    files
  end

  def file_diff(file)
    `git diff #{file}`
  end

  def files_name
    `git diff --name-only`.split /\n/
  end
end

