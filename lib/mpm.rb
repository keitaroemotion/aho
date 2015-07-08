
$target_mpm = "/usr/local/etc/aho/mpm"
$target_mpm_cont = "/usr/local/etc/aho/mpm_content"
$target_mpm_time = "/usr/local/etc/aho/mpm_time"
$scheme_tag = "{scheme}"
$scheme_jtag = "{scheme_j}"

def add_col()
  print "set column name: "
  key = $stdin.gets.chomp
  if (key == nil) || (key == "")
    add_col
  else
    print "set japanese(if exist): "
    value = $stdin.gets.chomp
    $hash[key] = value
    def ask_add_next()
      print "add next? [Y/n]: "
      case $stdin.gets.chomp
      when nil, ""
        ask_add_next
      when "y", "Y"
        add_col
      when "n", "N"
      else
        ask_add_next
      end
    end
    ask_add_next
  end
end

def set_scheme()
  $hash = Hash.new

  add_col
  scheme = "{scheme}"
  schemej = "{scheme_j}"

  $hash.each do |h|
    scheme += h[0].chomp+","
    schemej += h[1].chomp+","
  end

  scheme = scheme[0 .. scheme.size-2]
  schemej = schemej[0 .. schemej.size-2]

  f = File.open($target_mpm, "a")
  f.puts scheme
  f.puts schemej
  f.close
end

def make_mpm_file()
  if !File.exist? $target_mpm
    system "touch #{$target_mpm}"
  end
  if !File.exist? $target_mpm_cont
    system "touch #{$target_mpm_cont}"
  end
  if !File.exist? $target_mpm_time
    system "touch #{$target_mpm_time}"
  end
end

def get_schema_data()
  hash = Hash.new
  keys = Array.new
  vals = Array.new
  file_to_array($target_mpm).each do |line|
    if line.start_with?($scheme_tag)
      keys = line.gsub($scheme_tag, "").split(',')
    elsif line.start_with?($scheme_jtag)
      vals = line.gsub($scheme_jtag, "").split(',')
    end
  end
  (0..keys.size-1).each do |i|
    hash[keys[i]] = vals[i]
  end
  hash
end

def add_mpm()
  #read each scheme and let user register the data
  hash = get_schema_data
  line = ""
  input = ""
  hash.each do |h|
    if h[1] == nil
      continue
    end
    h[1] = h[1].strip
    if h[1] != ""
      print "#{h[1].chomp}: "
    else
      print "#{h[0].chomp}: "
    end
    input = $stdin.gets.chomp
    if input == nil
      input = "[BLANK]"
    elsif input == "q"
      break
    else
      line += "#{input},"
    end
  end
  if input != "q"
    f = File.open($target_mpm_cont, "a")
    text = line[0..line.size-2]
    f.puts text
    f.close
    puts "Written: #{text}".green
  end
end

def do_mpm(e, year, month, day)
  elems = e.strip.split(',')
  puts elems[0].green
  puts "\s\s#{elems[3]}".red
  if elems[4] != nil
    elems[4] == elems[4].strip
  end
  puts "\s\s#{elems[4]}".cyan
  puts "\s\s#{elems[5]}"
  print "This one? [Y/n]: "
  res = $stdin.gets.chomp
  case res
  when "q"
    return -1
  when nil, ""
    do_mpm e
  when "y", "Y"
    print "hours spent: "
    time = $stdin.gets.chomp
    time_data = Array.new # ->Hash

    file_to_array($target_mpm_time).each do |line|
      time_data.push line
    end
    cont = "#{elems[5]},#{time},#{year}-#{month}-#{day}"

    time_data.push "#{elems[5]},#{time},#{year}-#{month}-#{day}"

    print "#{year}-#{month}-#{day} ".cyan
    puts "ID: #{elems[5]} TIME: #{time}".red
    f = File.open($target_mpm_time, "w")
    time_data.each do |t|
      f.puts t
    end
    f.close
    puts "Registered: #{time} hours spent in #{elems[5]}"
    return -1
  when "n", "N"
    return 0
  else

  end
end

def get_mpm_date_elem(input)
  res = $stdin.gets.chomp
  if (res != nil) && (res.strip != "")
    return res.to_i
  else
    return input
  end
end

def exe_mpm(args)
  make_mpm_file
  oper = args[1]
  args = args[2..args.size-1]
  case oper
  when "set" # set scheme
    set_scheme
  when "inj", "i" #inject
    def inject_mpm()
      ts = Time.now
      year = ts.year
      month = ts.month
      day = ts.day
      print "Year[#{year}]: "
      year = get_mpm_date_elem(year)
      print "Month[#{month}]: "
      month = get_mpm_date_elem(month)

      print "Day[#{day}]: "
      day = get_mpm_date_elem(day)

      file_to_array($target_mpm_cont).each do |e|
        res = do_mpm e, year, month, day
        case res
        when -1
          break
        when 0
        else
        end
      end
    end
    inject_mpm
  when "add", "a"
    add_mpm
  when "alt"
    #query:  [col] is [val]
    print "column key: "
    col_key = $stdin.gets.chomp

    index = 0

    schemes = Array.new

    file_to_array($target_mpm).each do |line|
      if line.start_with? $scheme_tag
        line.split(',').each do |col|
          schemes.push col
        end
        line.split(',').each do |col|
          if col.strip == col_key.strip
            break
          end
          index += 1
        end
        break
      end
    end

    print "which one?: "
    col_val = $stdin.gets.chomp

    arr = Array.new

    file_to_array($target_mpm_cont).each do |line|
       lsp = line.split(',')
       if lsp[index].strip == col_val.strip
         i = 0
         newline = ""
         schemes.each do |s|
           x = lsp[i].strip.chomp
           if ((x == nil) || (x == ""))
             print "#{s.chomp} => ".yellow
           else
             print "#{x.chomp} => ".red
           end

           input = $stdin.gets.chomp
           if (input == nil) || (input == "")
             newline += "#{x},"
           else
             newline += "#{input},"
           end
           i += 1
         end
         arr.push newline[0 .. newline.size-2]
       else
         arr.push line
       end
    end

    f = File.open($target_mpm_cont, "w")
    arr.each do |a|
      f.puts a
    end
    f.close

  else
  end

  # add element
  # get calculated workhours of each per month
end
