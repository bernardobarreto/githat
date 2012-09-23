require File.dirname(__FILE__) + '/parser'

class Diff
  def initialize
    @files = get_files
  end

  def get_files
    names = get_names
  end

  def get_names
    `git diff --name-only`.split /\n/
  end
end

