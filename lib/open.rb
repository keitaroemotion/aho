def exe_open_kid(term)
  list = guess term
  if list.size == 0
  elsif list.size == 1
    list[0] = list[0].gsub(" ","\\ ")
    if("/applications/#{term}.app" != list[0].downcase)
      print "You want to open "
      print list[0].gsub($APP_DIR+"/",'').gsub(".app","").gsub("\\","").cyan
      print " ? [Y/n] : "
      if $stdin.gets.chomp.downcase != "y"
        bort
      end
    end
    system("open #{list[0]}")
  else
    puts list
  end
end

def exe_open()
  printf "Enter application name: "
  term = $stdin.gets.chomp
  exe_open_kid term
end



def open_rand(tag)
  filtered = true
  if tag == ""
   filtered = false
  end
  def open(stack, r)
    numero = 0
    stack.each do |line|
      if (numero == r)
        system("open #{line.split(',')[0]}")
      end
      numero = numero + 1
    end
  end

  numero = 0
  if filtered == false
    stack = Array.new
    File.open($target_file, "r").each do |line|
      stack.push line
      numero = numero + 1
    end
    r =  rand(numero)
    open stack, r
  else
    stack = Array.new
    File.open($target_file, "r").each do |line|
      if (tagexists(line, tag))
        stack.push line
        numero = numero + 1
      end
    end
    r =  rand(numero)
    open stack, r
  end
end

