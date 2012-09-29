require 'pygments.rb'

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
      head = heads[i]
      head = prepare_head_for_output(head) if i > 0 #TODO: wrong!
      parsed_head = parse_with_diff(prepare_head_for_output(head))
      parsed_code = parse_with_lang(codes[i], extension)
      parsed_code = parse_with_diff(parsed_code)
      complete_file_diff << (parsed_head + parsed_code)
    end

    complete_file_diff
  end

  def prepare_head_for_output(head)
    head.insert 0, "\n"
  end

  def file_extension(file_name)
    extension = file_name.gsub /(.+\.)/, ''
    if extension.empty? || file_name == extension
      extension = files_with_no_extension[file_name]
      extension ||= 'text'
    end
    extension.to_sym
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
    heads = diff.scan(/diff(?:.*\n){4}@@ .* @@/)
    heads << diff.scan(/^@@ .* @@/).tap(&:shift)
    heads.flatten
  end

  def file_diff(file)
    `git diff #{file}`
  end

  def files_names
    git_status.scan(/modified: .*/).map { |n| n.gsub(/modified: */, '') }
  end

  def git_status
    `git status`
  end

  def parse_with_lang(code, lang)
    process(code, lang)
  end

  def parse_with_diff(code)
    process(code, :diff)
  end

  def files_with_no_extension
    {
      'Gemfile' => :rb,
      'Gemfile.lock' => :rb,
      'Rakefile' => :rb,
      'Makefile' => :makefile
    }
    # TODO: support it: .*rake == rb
  end

  def process(code, lexer)
    Pygments.highlight code, formatter: 'terminal', lexer: lexer
  end
end

