$MEMO_DIR = "~/Documents/Aho_Memo"

def exe_memo()
  if File.directory?($MEMO_DIR) == false
    system("mkdir -p #{$MEMO_DIR}")
  end
  t = Time.now
  file_path  = "#{$MEMO_DIR}/#{t.year}-#{t.month}-#{t.day}.memo"
  Kernel.exec "vi #{file_path}; echo 'SAVED: #{file_path}'; aho"
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
