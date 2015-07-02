def exe_todo()
  puts
  print "Enter the operation:\n"+
        "\s\ss: show todos\n"+
        "\s\sa: add  todo\n"+
        "\s\sd: del  todo\n"+
        "\s\sq: quit\n"+
        "[todo]> "

  subop = $stdin.gets.chomp
  def putline()
    n = 0
    (1..60).each do |h|
      if n == 0
        print "-"
        n = 1
      else
        print "-".red
        n = 0
      end
    end
    puts
  end
  putline
  case subop
  when "q"
    bort
  when "qq"
    abort
  when "s"
    task
    exe_todo
  when "d"
    task
    puts
    taskdel
    task
    exe_todo
  when "a"
    taskadd
    exe_todo
  else
    exe_todo
  end
  putline
end


def getDateString()
  t = Time.now
  printf "Year[yyyy]#{t.year}:"
  year = assign($stdin.gets.gsub("\n",""), t.year)
  printf "Month[MM]#{t.month}:"
  month = assign($stdin.gets.gsub("\n",""), t.month)
  printf "Day[dd]#{t.day}:"
  day = assign($stdin.gets.gsub("\n",""), t.day)
  return  "#{year},#{month},#{day}"
end

def task()
  def format(str)
    str = str.to_s
    if str.size == 1
      return "0#{str}"
    else
      return str
    end
  end


  t = Time.now
  date = "#{t.year},#{t.month},#{t.day}"
  today_date = Time.now
  # actually putting in and comparing date obj is the most effective way...

  File.open($target_todo, "r").each do |line|

    def get_date(ls)
      year  =  ls[1].chomp
      month =  ls[2].chomp
      day   =  ls[3].chomp
      Time.new year, month, day
    end

    ls = line.split(',')
    haec_time = get_date(ls)

    def left_older(old, new) #
      yd = new.year - old.year
      if yd > 0
        return 0 # true
      elsif yd < 0
        return 1 # false
      else
        # could be equal : -1
      end
      md = new.month - old.month
      if md > 0
        return 0 # true
      elsif md < 0
        return 1 # false
      else
        # could be equal : -1
      end
      dd = new.day - old.day
      if dd > 0
        return 0
      elsif dd < 0
        return 1
      else
        return -1
      end
    end

    (1..ls.size-1).each do |i|
      compared_res = left_older(haec_time, today_date)
      if compared_res == 0
        print "#{format(ls[i].chomp).blue} "
      elsif compared_res == 1
        print "#{format(ls[i].chomp).green} "
      else
        print "#{format(ls[i].chomp).red} "
      end
    end
    print ls[0]
    puts
  end
end

def taskadd()
  date = getDateString
  printf "Text: "
  text = $stdin.gets.gsub(","," ").gsub("\n","")
  if text == ""
    bort "ERROR: you need to input text".red
  end
  text =  "#{text},#{date}"

  todos = Array.new
  if File.exist? $target_todo
    File.open($target_todo, "r").each do |e|
      todos.push e.gsub("\n","")
    end
  end

  f = File.open($target_todo, "a")

  if todos.include?("#{text}") == false
    f.puts text
  else
    puts "the following data already exists: #{text}"
  end
  f.close
end

def taskdel()
  date = getDateString
  print "Enter search word: "
  search_term = $stdin.gets.chomp
  if search_term == nil
    bort
  end
  def matches(line, search_term, date)
    if(line.downcase.start_with?(search_term.downcase))
      if(line.chomp.end_with?(date))
        return true
      end
    end
    return false
  end

  todos = Array.new
  File.open($target_todo, "r").each do |line|
    if !matches line, search_term, date
      todos.push line
    end
  end
  f = File.open($target_todo, "w")
  todos.each do |e|
    f.puts e
  end
  puts "--------------------------------------------------"
  f.close
end


