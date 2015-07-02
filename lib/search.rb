def exe_search()
  search_terms = get_args "Enter keywords:"
  if ((search_terms.size == 0) ||
     ((search_terms[0] == "q") && (search_terms.size == 1)))
    puts "[search quit!]"
    home
    return
  end
  numero = 0

  require 'open-uri'
  data = Array.new
  File.open($target_file, "r").each do |line|
   data.push line
  end

  progress = 0.0
  bar_max = 60.0

  lc = data.size

  data.each do |line|
    link =  line.split(',')[0]
    #print "seaching ...".green
    #print " #{link[0..30]}..".cyan
    pr = (bar_max * progress/lc).to_i # progress rate

    print "["
    (0..pr).each do |i|
      print "=".green
    end
    (0..(bar_max-pr)).each do |i|
      print "=".red
    end
    print "]"
    print "#{(progress/lc*100).to_i}% \r "
    def openlink(link)
      begin
        return open(link).read
      rescue
        return ""
      end
    end

    contents = openlink(link)

    def term_matches(search_terms, contents)
      search_terms.each do |term|
        if contents.include?(term) == false
          return false
        end
      end
      return true
    end

    if term_matches(search_terms, contents) == true
      system("open #{link}")
      numero = numero+1
    end
    progress += 1
  end

  print "["
  (0..bar_max).each do |i|
    print "=".green
  end
  print "]"
  print "100%"

  puts
  if numero == 1
    puts "1 page have been found.".yellow
  else
    puts "#{numero} pages have been found.".yellow
  end
end

