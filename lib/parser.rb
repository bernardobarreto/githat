require 'pygmentize'

class Pygmentize
  def self.process(source, lexer=nil)
    lex = lexer || 'text'
    args = ['-l', lex.to_s,
      '-f', 'terminal',
    ]

    IO.popen("#{bin} #{Shellwords.shelljoin args}", "r+") do |io|
      io.write(source)
      io.close_write
      io.read
    end
  end
end

