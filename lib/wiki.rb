$wiki_dir = "~/Documents/Wiki"

def open_wipath(path, word)
  puts
  puts word.upcase.green
  puts
  max_size = 6
  i = 0
  file_to_array(path).each do |line|
    if line.strip.start_with? "\""
      puts line.yellow
    else
      puts line
    end
    if i == max_size
      print "[Next]: ".red
      case $stdin.gets.chomp
      when "q"
        break
      else
      end
      i = 0
    end
    i += 1
  end
end

def gethomedir()
  home = %x(echo ~)
  homedir = $wiki_dir.gsub("~",home.chomp)
end

def get_file_name_wiki(homedir, file)
  return file.gsub("#{homedir}/","")
end

def list_wiki(query="")
  homedir = gethomedir
  wikis = Array.new
  Dir["#{homedir}/*"].sort_by!{ |m| m.downcase }.each do |file|
    filename = get_file_name_wiki(homedir, file)
    if filename.start_with? query
      wikis.push filename
    end
  end
  return wikis
end

def exe_wiki(args)
  op = args[1]

  case op
  when "la"
    query = ""
    if args[2] != nil
      query = args[2]
    end

    list_wiki(query).each do |w|
      puts w.green
    end
  when "e"
    word = ""
    if args.size < 3
       def make_word_interactive()
         word = ""
         print "Enter the word: "
         res = $stdin.gets.chomp
         if blank res
           puts "Enter the word!".red
           make_word_interactive
           # recur
         elsif res.strip == "q"
           return  nil
         else
           res.split(' ').each do |term|
             word += "#{term}_"
           end
         end
         return word
       end
       word = make_word_interactive
    else
      (2..args.size-1).each do |i|
        word += args[i]+"_"
      end
    end
    if word != nil
      word = word[0..word.size-2]
      if File.directory?($wiki_dir) == false
        system("mkdir -p #{$wiki_dir}")
      end
      wiki_path = "#{$wiki_dir}/#{word}"
      puts wiki_path.red
      Kernel.exec("vi #{wiki_path};  aho")
    end
  else #refer
    word = op
    if word == nil
      (0..4).each do |i|
        print "You need argument!\r".red
        sleep(0.3)
        print "                      \r"
        sleep(0.3)
      end
      puts
      puts "[word]    ... Show Word"
      puts "la    ... List All"
      puts "e [word]    ... Edit Wiki"
      puts
      home
    else
      wiki_path = "#{$wiki_dir}/#{word}"
      if File.exist? wiki_path
        open_wipath wiki_path, word
      else
        homedir = gethomedir
        files = Dir["#{homedir}/*"]
        delegetes = Array.new
        puts
        files.each do |file|
          filename = get_file_name_wiki(homedir, file)
          if filename.start_with? word
            delegetes.push file
            print "looking for... "
            puts filename.cyan
          end
        end

        delegetes.each do |file|
         def do_wiki_file(file, word, homedir)
           filename = file.gsub("#{homedir}/","")
           if filename == word
               open_wipath file, filename
           elsif filename.start_with? word
             print "Do you open "
             print "#{filename}".cyan
             print "? :[Y/n] "
             case $stdin.gets.chomp.downcase
             when "y"
               open_wipath file, filename
             when "n"
             else
               do_wiki_file file, word, homedir
             end
           end
         end
         do_wiki_file file, word, homedir
        end
      end
    end
  end
end
