$MEMO_DIR = "~/Documents/Aho_Memo"

def get_memo_res(val)
  res = $stdin.gets.chomp
  if blank(res)
    return val
  end
  return res
end


def exe_memo(args)
  args = args[1..args.size]
  if File.directory?($MEMO_DIR) == false
    system("mkdir -p #{$MEMO_DIR}")
  end

  t = Time.now

  case args[0]
  when "s"
    year = t.year
    month = t.month
    day = t.day

    print "Year[#{t.year}]:"
    year = get_memo_res(t.year)

    print "Month[#{t.month}]:"
    month = get_memo_res(t.month)
    print "Day[#{t.day}]:"
    day = get_memo_res(t.day)
    homedir = %x(echo ~)
    file = "#{$MEMO_DIR.gsub('~',homedir.chomp)}/#{year}-#{month}-#{day}.memo"
    if File.exist?(file) == false
      puts "file does not exist: #{file}"
    end
    file_to_array(file).each do |line|
      if line.strip != ""
        print "# ".green
        print line.chomp
        puts
        sleep(2)
      end
    end
  else
    file_path  = "#{$MEMO_DIR}/#{t.year}-#{t.month}-#{t.day}.memo"
    Kernel.exec "vi #{file_path}; echo 'SAVED: #{file_path}'; aho"
  end
end

def alt_document_dir()
  f = File.open($target_memo, "w") # config file
  print "Enter the document root directory: "
  docrootdir = $stdin.gets.chomp.strip

  if docrootdir == "~"
     docrootdir = %x(home)
  end

  if File.directory? docrootdir
    f.puts "#{docrootdir}"
  elsif docrootdir == "q"

  else
    puts "Directory #{docrootdir} doesn't exist...".red
    alt_document_dir
  end
  f.close
end
