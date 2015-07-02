require '/usr/local/etc/aho/lib/helper'
require '/usr/local/etc/aho/lib/const'

def makecash(url)
  makefile $target_webcash
  f =  File.open($target_webcash, "a")
  f.puts url
  f.close
end

def exe_web(args=nil)
  def search(args)
    url = "https://www.google.co.jp/search?q="
    if args.size == 0
      get_args("Enter search words:").each do |word|
        url += "#{word}+"
      end
    else
      args[1..args.size-1].each do |word|
        url += "#{word}+"
      end
    end
    url = url[0 .. url.size-2]
    system "open #{url}"
    makecash url
  end


  def exe(args=nil)
    op = ""
    if args == nil
      print "[Enter:]search [b:]back [q:]quit ?: "
      op = $stdin.gets.chomp
    else
    end
    case op
    when ""
      search args
      if args == nil
        exe
      end
    when "b"
      cashlist = file_to_array($target_webcash)
      print "Enter index: "
      i = $stdin.gets
      if (i == nil) || (i.strip.chomp == "")
        i = cashlist.size - 2
      else
        i = i.chomp.to_i
      end
      url = cashlist[i]
      system "open #{url}"
      makecash url
      exe
    when "q"
      home
    else
      exe
    end
  end
  exe args
end

