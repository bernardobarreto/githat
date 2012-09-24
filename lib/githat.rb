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
      heads, codes = splited[:heads], splited[:codes]
      complete_file_diff = ''

      (0...heads.size).each do |i|
        parsed_head = parse_with_diff(heads[i])
        parsed_code = parse_with_lang(codes[i], extension)
        parsed_code = parse_with_diff(parsed_code)
        complete_file_diff << (parsed_head + parsed_code)
      end

      complete_file_diff
    end

    def split_diff(diff)
      { heads: split_heads(diff),
        codes: split_codes(diff) }
    end

    def split_codes(diff)
      codes = []
      codes << diff.split(/^@@ .* @@/)
      codes.shift
    end

    def split_heads(diff)
      heads = []
      heads << diff.scan(/(?:.*\n){4}@@ .* @@/).first
      heads << diff.scan(/^@@ .* @@/).shift
      heads.flatten
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

    def files_with_no_extension
      {
        '.gitignore' => :diff,
        'Gemfile' => :rb,
        'Gemfile.lock' => :rb,
        'Rakefile' => :rb,
        'rake' => :rb
      }
    end

    def process(code, lexer)
      Pygmentize.process(code, lexer)
    end
  end
end

