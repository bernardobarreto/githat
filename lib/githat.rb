require File.dirname(__FILE__) + '/parser'

class Diff
  class << self
    def main
    end

    def files_infos
      files = []
      files_names.map do |name|
        files << { name: name, diff: file_diff(name) }
      end
      files
    end

    def parse_diff(file_info)
      extension = file[:name].gsub /(.*\.)/, ''
    end

    def file_diff(file)
      `git diff #{file}`
    end

    def files_names
      `git diff --name-only`.split /\n/
    end

    def parse_with_lang(code, lang)
      process(code, lang)
    end

    def parse_with_diff(code)
      process(code, :diff)
    end

    def process(code, lexer)
      Pygmentize.process(code, lexer)
    end
  end
end

