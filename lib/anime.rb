require 'colorize'
$CHAR = "                 Sam Goes to School."

def print_color(text, color)
   case color
   when 0
     print "#{text} \r".red
   when 1
     print "#{text} \r".cyan
   when 2
     print "#{text} \r".green
   when 3
     print "#{text} \r".blue
   when 4
     print "#{text} \r".yellow
   else
     print "#{text} \r \r"
   end
   sleep 0.2
end

def display_roll(text)
  (0..text.size-1).each do |k|
    print text[k..text.size-1].red
    if k > 0
      print text[0..k-1].green
    end
    #print "\r"
    puts
    sleep(0.2)
  end
  display_roll text
end


def display_color(text)
  text = "        #{text}"
  (0..5).each do |i|
    print_color text.chomp, i
  end
  print "text\r".black
end


=begin
[
"Sam goes to school",
"This is Gurunavi.",
"むみょいー."
].each do |t|
  display "     "+t
end

=end
