def show_linkmenu(oper, location_flag=false)
  if location_flag == true
    home
  else
    if oper == nil
      print_linkmenu
      oper = $stdin.gets.chomp.strip
    else
      location_flag = true
    end

    case oper
    when "q"
      bort
    when "qq"
      abort
    when "r"
      rm_link
    when "l"
      listlink()
      #tail
      show_linkmenu nil, location_flag
    when "a"
      addlink()
      show_linkmenu nil, location_flag
    when "x"
      open_rand ""
      show_linkmenu nil, location_flag
    when "o"
      #todo: list tag
      print "Enter the tag: "
      tag = $stdin.gets.chomp
      open_rand tag
      tail
      show_linkmenu nil, location_flag
    when "t", "tag"
      list_tags
      #tail
      show_linkmenu nil, location_flag
    else
      # this time, rand open per tag
      # regard oper as tag
      if oper.start_with? "http"
        stash_link oper, Array.new
      else
        open_rand oper
      end
      show_linkmenu nil, location_flag
    end
  end
end




def tail()
  print ""
  $stdin.gets.chomp
end
def print_linkmenu()
  puts "----------------------------".green
  printf "Your action is:\n"+
       "\s\sl: list all links\n"+
       "\s\sa: add link\n"+
       "\s\sx: open random link\n"+
       "\s\so: open tag-based random link\n"+
       "\s\st: list tags\n"+
       "\s\sr: remove link\n"+
       "\s\sq : quit\n"+
       "------------------------------\n".green
       print "[link]> "
end




def addlink(urllink=nil, tags=nil)
  from_global = true
  if urllink == nil
    from_global = false
    print "url: "
    urllink = $stdin.gets.chomp
  end
  if tags == nil
    from_global = false
    print "tags (ex: tag1 tag2 tag3): "
    tags = Array.new
    $stdin.gets.chomp.split(' ').each do |tag|
      tags.push tag
    end
  end

  stash_link(urllink, tags)
  def askin()
    puts
    print ":q = quit , Enter: = next ?:  "
    case $stdin.gets.chomp
    when "q"
     show_linkmenu "q"
    when ""
     addlink
    else
     askin
    end
  end
  if from_global == false
    askin
  end
end


def rm_link()
  lines = Array.new
  flag = 0
  File.open($target_file,"r").each do |line|

    def ask_line_of_deletion(line)
      print "You wanna remove this link?:\n"
      ls = line.split($COMMA)
      (1..ls.size-1).each do |x|
        print "["
        print ls[x].chomp.green
        print "] "
      end
      print  ls[0].blue
      print " (:y = Yes,  :Enter = No, :q = Quit): "
      res = $stdin.gets.chomp.downcase
      if res == ""
        return line
      elsif res == "q"
        return "-1"
      elsif res == "y"
        puts
        printf "DELETED!".red
        puts
        puts
        return ""
      else
        return ask_line_of_deletion(line)
      end
    end

    if flag == 1
      lines.push line
    else
      line = ask_line_of_deletion line
      if line == "-1"
        flag = 1
      elsif line == ""
      else
        lines.push line
      end
    end
  end

  f = File.open($target_file, "w")
  lines.each do |line|
    f.puts line
  end
  f.close
  tail
  show_linkmenu
end


def list_tags()
  bucket = Array.new
  File.open($target_file, "r").each do |line|
    ls = line.split(',')
    (1 .. ls.size-1).each do |e|
      if bucket.include?(ls[e].chomp) == false
        bucket.push ls[e].chomp
      end
    end
  end
  counter = 0
  hor_len = 6
  bucket.each do |tag|
    if counter == hor_len
      puts
      counter = 0
    else
      print "[#{tag.green}]"
    end
    counter += 1
  end
  puts
end

def stash_link(link, tags)
  FileUtils.mkdir_p $target_dir

  arr = Array.new
  counter = 0
  if File.exist? $target_file
    File.open($target_file, "r").each do |line|
      #stash maximum 1000, the olderst eliminated
      if counter < $STASH_HEAP
        arr.push line
      end
      counter = counter + 1
    end
  end

  f = File.open($target_file, "w")
    if tags.size > 0
      for i in (0 .. tags.size-1) do
         link = link + ",#{tags[i]}"
      end
    end
    if link.start_with? "http"
      f.puts link
    end

    arr.each do |line|
      f.puts line
    end
  f.close
end



def format_link_et_tag(line)
  lsp = line.split(',')
  limit = 60
  if lsp.size > 1
    (1..lsp.size-1).each do |e|
      printf "["
      printf "#{lsp[e].chomp.green}"
      printf "]"
    end
    if lsp[0] != nil
      puts  "#{lsp[0][0..limit]}"
    else
      puts
    end
  else
    puts "[none] #{line[0..limit]}"
  end
end

def listlink(tag=nil)
  File.open($target_file, "r").each do |line|
    if ((tag == nil) || tagexists(line, tag))
      format_link_et_tag(line)
    end
  end
end

