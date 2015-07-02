def exe_book()
  case getsubop
  when "r"
    regbook
    exe_book
  when "s"
    showkeys
    exe_book
  when "d"
    delbook
    exe_book
  when "o"
    openbook
    exe_book
  when "q"
  when "qq"
    abort
  else
    exe_book
  end
end


def getsubop()
  if ARGV[1] != nil
    return  ARGV[1]
  else
    print "Choose operation:\n"+
        "\s\sr: register new link \n"+
        "\s\ss: show links        \n"+
        "\s\so: open link         \n"+
        "\s\sd: delete link       \n"+
        "\s\sq: quit              \n"+
        "[book]> "
    return $stdin.gets.chomp
  end
end


def showkeys()
  numero = 0
  file_to_key_array($target_bookmark).each do |key|
    print "["; print "#{key}".cyan; print "]"
    if(numero == 5)
      puts
    end
    numero += 1
  end
  puts
end


def openbook(key = nil)
  opened = false
  if key == nil
    showkeys
    print "Enter the key to open: "
    key = $stdin.gets.chomp
  end
  file_to_array($target_bookmark).each do |line|
    ls = line.split(',')
    if ls[1].chomp == key
      system("open #{ls[0].chomp}")
      opened = true
    end
  end
  if opened == false
    file_to_array($target_bookmark).each do |line|
      ls = line.split(',')
      if ls[1].chomp.start_with? key
        print "Do you want to open "
        print ls[1].chomp.green
        print " ("
        print "#{ls[0].chomp.yellow}"
        print ") ? [Y/n]"
        if $stdin.gets.chomp.downcase == "y"
          system("open #{ls[0].chomp}")
        end
      end
    end
  end
end



def regbook()
  print "Enter the url:"
  url = $stdin.gets.chomp
  if !url.start_with? "http"
    url = "http://#{url}"
  end
  print "Enter the key:"
  key = $stdin.gets.chomp

  keys = file_to_key_array($target_bookmark)

  f = File.open($target_bookmark, "a")
  if keys.include? key
    puts "the key '#{key}' has already been registered."
  else
    f.puts "#{url},#{key}"
  end
  f.close
end


def delbook()
  showkeys
  print "Enter the key to delete: "
  key = $stdin.gets.chomp
  copy = Array.new
  file_to_array($target_bookmark).each do |line|
    ls = line.split(',')
    if ls[1].chomp == key
      print "the key".green
      print " #{key} ".red
      print "has been deleted.".green
      puts
    else
      copy.push line
    end
  end
  f = File.open($target_bookmark, "w")
  copy.each do |line|
    f.puts line
  end
  f.close
end

