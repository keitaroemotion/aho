
def quit?(word = 'q')
  begin
    # See if a 'Q' has been typed yet
    while c = STDIN.read_nonblock(1)
      case c.downcase
      when 'q'
        return 0
      when 's'
        return 2
      when 'f'
        return 1
      else
      end
    end
    # No 'Q' found
    false
  rescue Errno::EINTR
    puts "Well, your device seems a little slow..."
    -1
  rescue Errno::EAGAIN
    # nothing was ready to be read
    -1
  rescue EOFError
    # quit on the end of the input stream
    # (user hit CTRL-D)
    puts "Who hit CTRL-D, really?"
    0
  end
end
