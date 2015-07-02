require '/usr/local/etc/aho/lib/const'

def puts_alias_show_content(index, compact , color=$CYAN)
  if compact
    text = ""
    horsize = 50
    texts = Array.new
    file_to_map($target_alias).each do |key|
      text += "[#{key[index]}] "
      if text.size > 50
        texts.push text
        text = ""
      end
    end
    if text != ""
      texts.push text
    end
    texts.each do |line|
      cputs line, color
    end
  else
    file_to_map($target_alias).each do |key|
      cputs key[index], color
    end
  end
end

def alt_key()
  puts_alias_show_content 0, true , $GREEN
  print "Enter the old key: "
  oldkey = $stdin.gets.chomp
  if (oldkey == "q") || (oldkey == "")
    exe_alias
  else
    print "Enter the new key: "
    newkey = $stdin.gets.chomp
    lines = Array.new
    file_to_map($target_alias).each do |d|
      if d[0] == oldkey
        lines.push "#{newkey},d[1]"
      else
        lines.push "#{d[0]},#{d[1]}"
      end
    end
    f = File.open($target_alias, "w")
    lines.each do |line|
      f.puts line
    end
    f.close
  end
  return newkey
end

def show_all_alias()
  file_to_map($target_alias).each do |elem|
    cputs "[#{elem[0]}] #{elem[1]}", $YELLOW
  end
end

def alias_dispatched()
  print "keys:[k] links:[l] all:[a] quit:[q]?: "
  res = $stdin.gets.chomp
  case res
  when $COMM_ABORT
   abort
  when $COMM_BACK
    exe_alias
  when "a"
    show_all_alias
    alias_dispatched
  when "l"
    puts_alias_show_content 1, false , $GREEN
    alias_dispatched
  when "k"
    puts_alias_show_content 0, true
    alias_dispatched
  else
    alias_dispatched
  end
end

def exe_alias()
  makefile $target_alias
  case show_alias_menu
  when $OPEN
    print "Enter the key: "
    system file_to_map($target_alias)[$stdin.gets.chomp]
  when $SHOW
    alias_dispatched
  when $ADD
    add_alias
    exe_alias
  when $DELETE
    puts_alias_show_content 0, true , $GREEN
    def declare_deletion(key)
      puts
      print "the key "
      print key.red
      print " has been deleted."
      puts
    end

    def delete_by_key(file, key)
      lines = Array.new
      if (key == nil)||(key.strip == "")
        puts
        puts "enter the key!".red
        puts
        exe_alias
      end
      file_to_map(file).each do |e|
        if e[0] == key
          declare_deletion key
        elsif e[0].strip.start_with? key
          print "You wanna erase "
          print e[0].red
          print " ? [y]:delete [Enter]:never :  "
          if $stdin.gets.chomp.downcase == "y"
            declare_deletion key
          else
            lines.push "#{e[0]},#{e[1]}"
          end
        else
          lines.push "#{e[0]},#{e[1]}"
        end
      end
      f = File.open(file,"w")
      lines.each do |line|
        f.puts line
      end
      f.close
    end
    print "Enter the key to delete: "
    delete_by_key $target_alias, $stdin.gets.chomp
    exe_alias
  when $RENAME
    def alt_value(key="")
      puts_alias_show_content 0, true , $GREEN
      if key == ""
        print "Enter the key for change: "
        key = $stdin.gets.chomp
      end
      if (key == "q") || (key == "")
      else
        lines = Array.new
        file_to_map($target_alias).each do |d|
          if d[0] == key
            print "[current value]: #{d[1]}\n".yellow
            print "Enter new value: "
            lines.push "#{key},#{$stdin.gets.chomp}"
          else
            lines.push "#{d[0]},#{d[1]}"
          end
        end
        f = File.open($target_alias, "w")
        lines.each do |line|
          f.puts line
        end
        f.close
      end
    end
    print "Which to alter? [k:Key] [v:Value] [b:Both]? : "
    case $stdin.gets.chomp.downcase
    when "k"
      alt_key
    when "v"
      alt_value
    when "b"
      alt_value alt_key
    else
      puts "input should be 'k' or 'v'".red
    end
    exe_alias
  when $COMM_ABORT
    abort
  when $COMM_BACK
    home
  else
    exe_alias
  end
end

def add_alias()
  command = ""
  alia_s = ""
  print "[Enter Command:]$ "
  command = $stdin.gets.chomp
  if (command == nil) || (command == "")

  else
    print "[Enter Alias:] "
    alia_s = $stdin.gets.chomp
    def has_aliaskey(key)
      file_to_array($target_alias).each do |line|
        if line.start_with? "#{key},"
          return true
        end
      end
      return false
    end
    f = File.open($target_alias, "a")
    if has_aliaskey(alia_s)
      print "ERROR: the key "
      print "#{alia_s}".red
      puts " has already been registered."
    else
      f.puts "#{alia_s}#{$COMMA}#{command}"
    end
    f.close
  end
end

def show_alias_menu()
  puts "#{$SHOW} ... show alias"
  puts "#{$OPEN} ... open alias"
  puts "#{$ADD} ... add alias"
  puts "#{$DELETE} ... delete alias"
  puts "#{$RENAME} ... rename alias"
  puts "#{$COMM_BACK} ... home"
  puts "#{$COMM_ABORT} ...quit application "
  show_home "area"
  print "> "
  return $stdin.gets.chomp
end

