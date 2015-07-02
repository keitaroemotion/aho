def blank(term)
  return ((term == nil)||(term == "")||(term.strip.chomp == ""))
end

def cputs(text, color="")
  case color
  when $CYAN
    puts text.cyan
  when $GREEN
    puts text.green
  when $RED
    puts text.red
  when $YELLOW
    puts text.yellow
  else
    puts text
  end
end

def makefile(file)
  if File.exist?(file) == false
    system("touch #{file}")
  end
end

def show_home(area)
  print "["
  print area.yellow
  print "]"
end


def exe_help()
  help
  print "[#{$GROUND}]> "
  operate $stdin.gets.chomp
end

def file_to_map(file)
  hash = Hash.new
  if File.exist? file
    File.open(file, "r").each do |line|
      if line.include? ','
        ls = line.split(',')
        hash[ls[0]] = ls[1].gsub("\n","")
      end
    end
  end
  hash
end

def file_to_array(file)
  arr = Array.new
  if File.exist? file
    File.open(file, "r").each do |line|
      arr.push line
    end
  end
  arr
end

def file_to_key_array(file)
  arr = Array.new
  if File.exist? file
    File.open(file, "r").each do |line|
      ls = line.split(',')
      arr.push ls[1].chomp
    end
  end
  arr
end



def assign(from, to)
  if from == ""
    from = to
  end
  from
end


def tagexists(line, tag)
  lsp = line.split(',')
  return  (lsp.include?("#{tag}\n")) || (lsp.include?(tag))
end


def guess(key)
  list = Array.new
  Dir["#{$APP_DIR}/*"].each do |app|
    if app.gsub("#{$APP_DIR}/","").gsub("\ ","").downcase.start_with? key.downcase
      list.push app
    end
  end
  list
end

def chomp()
  res = $stdin.gets
  if res != nil
    return res.chomp
  else
    abort "nil"
  end
end

def split_by_space(text)
  if text == nil
    puts "ERROR: nil text"
    return ""
  end
  ts = text.split(' ')
  if ts[0] == nil
    return text.chomp
  else
    return ts[0].chomp
  end
end


def get_args(msg)
  printf "#{msg} "
  arr = Array.new
  chomp().split(' ').each do |e|
    arr.push e
  end
  if arr.size == 0
    bort "ERROR: argument non sufficient"
  end
  arr
end

require '/usr/local/etc/aho/lib/const.rb'


def bort(msg="")
  print msg.red
  print "["
  print "#{$GROUND}".yellow
  print "]> "
  operate chomp()
end

def home()
end

def help()
  line = "==========================================="
  tab = "                  "
  puts line
  printf tab
  puts "†aho †  ".cyan
  puts line
  def puts_c(a,b)
    printf a.green
    printf b
    puts
  end
  puts_c "kill or k      ", " ... kill the application starts with the kw"
  puts_c "web  or w      ", " ... search with browser "
  puts_c "wi [la]            ", " ... list all words in wiki  "
  puts_c "wi [e] [new word]           ", " ...  edit wiki  "
  puts_c "wi [word]           ", " ...  see wiki  "
  puts_c "link or l      ", " ... links"
  puts_c "l [tag]        ", " ... open random link with tag"
  puts_c "l [url] [tag1=optional] [tag2] [tag3] ...      ", " ... add links with tags"
  puts_c "todo or t      ", " ... manage todo"
  puts_c "book or b      ", " ... bookmarking function"
  puts_c "//             ", " ... open the link containing the keyword"
  puts_c "a            ", "   ... alias menu"
  puts   "------------------------------------------------------".blue
  puts_c "al             ", "   ... show all alias"
  puts_c "bl             ", " ... show bookmark keys"
  puts_c "tl             ", " ... show link tags"
  puts   "------------------------------------------------------".blue
  puts_c "q              ", " ... if at home, quit app and else go back home"
  puts_c "qq              ", "... force to quit application"
  puts_c "help or h       ", "... help menu"
end

