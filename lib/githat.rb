require File.dirname(__FILE__) + '/parser'

module Diff
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
    extension = file_extension(file_info[:name])
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

  def file_extension(file_name)
    extension = file_name.gsub /(.+\.)/, ''
    if extension.empty? || file_name == extension
      extension = files_with_no_extension[file_name]
      extension ||= 'text'
    end
    extension
  end

  def split_diff(diff)
    { heads: split_heads(diff),
      codes: split_codes(diff) }
  end

  def split_codes(diff)
    codes = diff.split(/^@@ .* @@/)
    codes[1..codes.size]
  end

  def split_heads(diff)
    heads = diff.scan(/(?:.*\n){4}@@ .* @@/)
    heads << diff.scan(/^@@ .* @@/)[1..heads.size] #TODO: this should not work (heads size==1?)
    heads.flatten
  end

  def file_diff(file)
    `git diff #{file}`
  end

  def files_names
    `git diff --name-only`.split(/\n/)
  end

  def parse_with_lang(code, lang)
    process(code, lang)
  end

  def parse_with_diff(code)
    process(code, :diff)
  end

  def files_with_no_extension
    {
      'Gemfile' => 'rb',
      'Gemfile.lock' => 'rb',
      'Rakefile' => 'rb',
      'Makefile' => 'makefile'
    }
    # TODO: support it: .*rake == rb
  end

  def process(code, lexer)
    Pygmentize.process(code, lexer)
  end
end

