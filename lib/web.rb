require '/usr/local/etc/aho/lib/helper'
require '/usr/local/etc/aho/lib/const'

def makecash(url)
  makefile $target_webcash
  f =  File.open($target_webcash, "a")
  f.puts url
  f.close
end

def exe_web()
  def search()
    url = "https://www.google.co.jp/search?q="
    get_args("Enter search words:").each do |word|
      url += "#{word}+"
    end
    url = url[0 .. url.size-2]
    system "open #{url}"
    makecash url
  end


  def exe()
    print "[Enter:]search [b:]back [q:]quit ?: "
    case $stdin.gets.chomp
    when ""
      search
      exe
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
  exe
end

