require 'pygmentize'

class Pygmentize
  def self.process(source, lexer)
    args = ['-l', lexer.to_s,
      '-f', 'terminal',
      "-O", "encoding=#{source.encoding}"
    ]

    IO.popen("#{bin} #{Shellwords.shelljoin args}", "r+") do |io|
      io.write(source)
      io.close_write
      io.read
    end
  end
end

