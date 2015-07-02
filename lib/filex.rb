def exe_rename()
  dir_location = "#{ARGV[1]}/*"
  from = ARGV[2]
  to = ARGV[3]
  if ARGV.size < 4
    bort "argument size non sufficient"
  end
  Dir[dir_location].each do |file|
    #if file.include? from
    #end
    puts file
  end
end


def del()
  #solve conflict!
  command = "mv "
  (1 .. ARGV.size-1).each do |x|
    file = ARGV[x]
    filepath = "~/.Trash/#{file}"
    puts "fp: #{filepath}"
    if (File.exist?(filepath) || Dir.exist?(filepath))
      puts "pass"
      file2 = file + Time.now.to_s
      system("mv #{file} #{file2}")
    end
    command += "#{file} "
  end
  command += "~/.Trash"
system(command)
end
