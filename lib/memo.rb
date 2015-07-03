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
  (0 .. maxsize).each do |e|
    hor_edge += "-"
  end
  hor_edge +=  "+"
end

def num_alloc_memo(total)
  bl = ""
  num = 0
  if total%2 == 0
    num = total/2
  else
    num =  (total-1)/2
  end
  (0..num-1).each do |i|
    bl += " "
  end
  return bl
end

def graph_engine(line)
  # katati box dx dy w h v1 v2 v3
  lines = line.strip.split(' ')
  if lines[0] == "katati"
    args = lines[1..line.size-1]
    func = args[0]
    case func
    when "box"
      cont = args[1..args.size-1]
      maxsize = 0 # equals the horizontal size - 2?
      cont.each do |text|
        if (maxsize < text.size)
          maxsize = text.size
        end
      end

      strips = Array.new
      hor_edge = get_hor_edge maxsize

      strips.push hor_edge

      cont.each do |value|
        al_num = num_alloc_memo(maxsize)
        value = "|" + al_num + value
        total = maxsize-value.size+1

        #(0..maxsize-value.size+1).each do |i|
        #  value += " "
        #end
        (0..(total-al_num.size)).each do |x|
          print " "
        end
        value += "|"
        strips.push value
      end
      strips.push hor_edge

      puts strips

    else
    end
  else
    print line
  end
end


def scroll_memo(year, month, day, ans)
  file = get_file_memo(year, month, day)
  if File.exist?(file) == false
    puts "file does not exist: #{file}"
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
        if line.strip.start_with? "*"
          print line.cyan
        elsif line.strip.start_with? "-"
          print line.yellow
        elsif line.start_with? "###"
          print line.green
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
  show_viz file, ans
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

    print "Month[#{t.month}]:"
    month = get_memo_res(t.month)
    print "Day[#{t.day}]:"
    day = get_memo_res(t.day)
    print  "scroll? [Y/n]: "
    ans = $stdin.gets.chomp
    # => recursive


    def memo_disp_main(year, month, day, ans)
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
        scroll_memo year, month, day, ans
      end
      #recursive
      if $op != $QUIT
        memo_disp_main(year, month, day, ans)
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
