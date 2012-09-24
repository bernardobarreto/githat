require File.dirname(__FILE__) + '/parser'

class Diff
  class << self
    def main
      output = ''
      files_infos.each do |file|
        output << parse_diff(file)
      end
      output
    end

    def files_infos
      files = []
      files_names.map do |name|
        files << { name: name, diff: file_diff(name) }
      end
      files
    end

    def parse_diff(file_info)
      extension = file_info[:name].gsub /(.*\.)/, ''
      splited = split_diff(file_info[:diff])
      parsed_head = parse_with_diff(splited[:head])
      parsed_code = parse_with_lang(splited[:code], extension)
      parsed_code = parse_with_diff(parsed_code)
      parsed_head + parsed_code
    end

    def split_diff(diff)
      head = diff.scan(/diff(?:.*\n){4}@@.*@@/).first
      code = diff.gsub(/diff(?:.*\n){5}/, '').strip
      { head: head, code: code }
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

