require '/usr/local/etc/aho/lib/helper'


def kill(term)
  list = guess term
  if list.size == 1
    res = %x(ps aux | grep "#{list[0].gsub(" ","\\ ")}")
    whoami = %x(whoami).chomp
    puts "Do you really want #{list[0]} be dead? [Y/n]"
    ans = $stdin.gets.chomp
    if (ans.downcase == "y")
      res.split(whoami).each do |l|
        if (!l.include? "grep")
          system ("kill #{split_by_space(l)}")
        end
      end
    else
    end
  else
    puts list
  end
end


def exe_kill(args=nil)
  if args != nil
    args = args[1..args.size-1]
  else
    args = get_args "Enter the app name to kill:"
  end
  args.each do |proc|
    kill proc
  end
end

