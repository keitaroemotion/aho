$MEMO_DIR = "~/Documents/Aho_Memo"

require '/usr/local/etc/aho/lib/iox'

$op = 1
$QUIT = 0
$DEF = 1
$speed = 2

def get_memo_res(val)
  res = $stdin.gets.chomp
  if blank(res)
    return val
  end
  return res
end

def get_correct_memodir()
  homedir = %x(echo ~)
  return $MEMO_DIR.gsub('~',homedir.chomp)
end

def get_file_memo(year, month, day)
  return "#{get_correct_memodir}/#{year}-#{month}-#{day}.memo"
end

def get_hor_edge(maxsize)
  hor_edge = "+"
  (1 .. maxsize).each do |e|
    hor_edge += "-"
  end
  hor_edge +=  "+"
end

def get_half_pane(totalsize, text)

  #      T O T A L  S I Z E
  #  +-------------------------+
  #  |   |te |xt |si |ze |diff |
  #  +-------------------------+
  #  half                 half
  #  pane                 pane
  totalsize = totalsize.to_i
  textsize = text.size
  diff = totalsize - textsize.to_i
  if diff % 2 == 0
    return diff/2
  else
    return ((diff+1)/2)-1
  end
end

$GRAPH_COMMAND = "ktt"

def make_box(cont)
  maxsize = 0 # equals the horizontal size - 2?
  cont.each do |text|
    if (maxsize < text.size)
      maxsize = text.size
    end
  end
  strips = Array.new
  strips.push maxsize.to_s
  hor_edge = get_hor_edge maxsize
  # +-- .... --+
  strips.push hor_edge

  cont.each do |value|
    half_pane = get_half_pane(maxsize,value)
    value_mod = "|"
    (1 .. half_pane).each do |blank|
      value_mod += " "
    end
    value_mod += value
    (1 .. (maxsize - half_pane - value.size)).each do |blank|
      value_mod += " "
    end
    value = value_mod
    strips.push value+"|"
  end
  # +-- .... --+
  strips.push hor_edge
end

def write_interval(inter_x, index, middle_y)
  mark = " "
  if index == middle_y
    mark = "-"
  end
  (1..inter_x).each do |d|
    print mark.yellow
  end
end

def graph_engine(line)
  # katati box dx dy w h v1 v2 v3
  lines = line.strip.split(' ')
  if lines.size == 0
    lines = ["ktt","box","hoi","hen", "ssss"]
  end
  if lines[0] == "ktt"
    args = lines[1..line.size-1]
    func = args[0]
    case func
    when "box"
      box = make_box args[1..args.size-1]
      box2 = make_box ["nyan", "nnnya", "hoahoa","moo"]

      inter_x = 5
      dx      = inter_x + box[0].to_i
      middle_y = (box.size-1)/2


      (1 .. box.size-1).each do |index|
         print box[index]
         write_interval inter_x, index, middle_y
         print box2[index]
         puts
      end

      if box2.size > box.size
        (box.size .. box2.size-1).each do |x|
          (1 .. box[0].to_i+2).each do |i|
            print "#"
          end

          write_interval inter_x, 0, 0
          print box2[x].red
          puts
        end
      end


      #puts box
      #puts box2
    else
    end
  else
    print line
  end
end

require '/usr/local/etc/aho/lib/wiki'
$wiki = list_wiki

def line_include_wiki(line)
  $wiki.each do |w|
     if line.downcase.include? " #{w} "
       return w
     end
  end
  return nil
end

def show_viz(file, ans)
  lines = file_to_array(file)
  i = 0
  lines.each do |line|
    if line.strip != ""
      prog =  "#{(i.to_f/lines.size.to_f*100).to_i}% ".to_s
      print "[".blue
      (1..(4-prog.size)).each do |r|
        prog += " "
      end
      print prog.cyan
      print "] ".blue
      line = line.chomp
      kw = line_include_wiki(line)
      if line.strip.start_with? "*"
        print line.cyan
      elsif line.strip.start_with? "-"
        print line.yellow
      elsif line.start_with? "###"
        print line.green
      elsif kw != nil
        lsp = line.split(kw)
        print "#{lsp[0]} "
        print kw.upcase.magenta.blink
        print " #{lsp[1]}"
      else
        print line
      end

      puts
      interr = quit?
      case interr
      when 0
        $op = $QUIT
        break
      when 1
        $speed -= 0.4
        if $speed < 0
         $speed = 2
        end
        puts "Velocity: #{'%.2f' % $speed}".green
      when 2
        $speed += 0.2
        puts "Velocity: #{'%.2f' % $speed}".green
      end

      if ans == "y"
        sleep($speed)
      end
    end
  i += 1
  end
end

def scroll_memo(year, month, day, ans)
  file = get_file_memo(year, month, day)
  bad = false
  if File.exist?(file) == false
    puts "file does not exist: #{file}"
    bad = true
  end

  if bad == false
    show_viz file, ans
  end
  return bad
end

def exe_memo(args)
  args = args[1..args.size]
  if File.directory?($MEMO_DIR) == false
    system("mkdir -p #{$MEMO_DIR}")
  end

  t = Time.now

  case args[0]

  when "sx"

  when "s"
    $op = $DEF
    # engine
    year = t.year
    month = t.month
    day = t.day

    print "Year[#{t.year}]:"
    year = get_memo_res(t.year)
    home = %x(echo $HOME).chomp
    memodir = "#{$MEMO_DIR.gsub('~',home).chomp}"
    puts memodir

    data = Array.new

    Dir["#{memodir}/*".chomp].each do |file|
      filename = "#{file.gsub(memodir.chomp, '').gsub('.memo','').gsub('/','')} "
      file_tokens = filename.split('-')
      monthkey = file_tokens[1]
      day = file_tokens[2]
      yearkey = file_tokens[0]

      if yearkey.strip.to_i == year
        data.push  [monthkey, day]
      end

    end

    hash = Hash.new
    data.each do |date|
      hash[date[0]] = date[1]
    end

    print "#{year} ".red
    print "| "
    hash.keys.each do |x|
      print "#{x.green} "
    end
    puts

    print "Month[#{t.month}]:"
    month = get_memo_res(t.month)

    puts hash[month.to_s.chomp.strip]

    print "Day[#{t.day}]:"
    day = get_memo_res(t.day)
    print  "scroll? [Y/n]: "
    ans = $stdin.gets.chomp
    # => recursive


    def memo_disp_main(year, month, day, ans)
      bad = false
      if (day == "all") || (day == "a")
        (1..31).each do |d|
          if $op == $QUIT
            break
          end
          file = get_file_memo(year, month, d)
          if File.exist? file
            puts
            print "#{year} #{month}/#{d}".red
            puts
            scroll_memo year, month, d, ans
          end
        end
      else
        bad = scroll_memo year, month, day, ans
      end
      #recursive
      if $op != $QUIT
        if bad == false
          memo_disp_main(year, month, day, ans)
        end
      end
    end
    memo_disp_main(year, month, day, ans)
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
