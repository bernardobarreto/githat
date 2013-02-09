# code from http://nex-3.com/posts/73-git-style-automatic-paging-in-ruby

def paginate
  # doesn't run under Windows
  require 'rbconfig'
  return if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/

  return unless STDOUT.tty?

  read, write = IO.pipe

  unless Kernel.fork # child process
    STDOUT.reopen(write)
    STDERR.reopen(write) if STDERR.tty?
    read.close
    write.close
    return
  end

  # parent process becomes pager
  STDIN.reopen(read)
  read.close
  write.close

  ENV['LESS'] = 'FSRX' # Don't page if the input is short enough

  Kernel.select [STDIN] # Wait until we have input before we start the pager
  pager = ENV['PAGER'] || 'less'
  exec pager rescue exec '/bin/sh', '-c', pager
end

paginate