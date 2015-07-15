require 'colorize'
require 'date'
require '/usr/local/etc/aho/lib/controller.rb'

option = ARGV[0]

$d = DateTime.now
$haec_annus = $d.year
$haec_mensis = $d.month

def complement_year(year)
  if year.to_s == 2
    return "20#{year}"
  end
end

COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

def days_in_month(month, year = Time.now.year)
   return 29 if month == 2 && Date.gregorian_leap?(year)
   COMMON_YEAR_DAYS_IN_MONTH[month]
end

def nanciscorRatio(hour, minute)
  maximus_consummatio = 9.0*60.0
  haec_consummatio =  ((hour-9.0)*60.0)+minute.to_f
  (haec_consummatio/maximus_consummatio*100.0).to_i
end

$haec_uno_dies = DateTime.new($haec_annus.to_i,$haec_mensis.to_i,1).wday

def showTempus(d)
  minute = d.minute.to_s
  if minute.size == 1
   minute = "0"+minute
  end

  time = "%s:%s " % [d.hour, minute]
  printf time.colorize(:cyan)
  printf "["
  percentage =  "%i" % [nanciscorRatio(d.hour, d.minute)]
  allelem = 12.0
  ratioA = (allelem * percentage.to_f/100.0).to_i
  ratioB = allelem - ratioA

  mark = "!"

  (1..ratioA).each { |x|
   printf mark.yellow
  }

  (1..ratioB).each { |x|
   printf mark
  }
  printf "]"

  if percentage == "100"
    percentage = "FIN"
  end
  printf percentage.cyan
  if percentage != "FIN"
    printf "%"
  end


  puts
end



$timesepatationkey = "time="

def convertIntIntoString(int)
  case int
  when 0
    return "su"
  when 1
    return "mo"
  when 2
    return "tu"
  when 3
    return "we"
  when 4
    return "th"
  when 5
    return "fr"
  when 6
    return "sa"
  end
end

def print_wod()
  ["Su","Mo","Tu","We","Th","Fr","Sa"].each { |dow|
    printf dow+" "
  }
  puts
end

$todos =  Controller.get_text($haec_annus.to_i, $haec_mensis.to_i, $d.day)

$count = 0
$striplen = 0
$maxlen = 21

def entail(striplen, maxlen)
  if (striplen < maxlen)
    (1..maxlen-$striplen).each { |s|
      printf " "
    }
  end
end

def disp()
  $d = DateTime.now
  $haec_annus = $d.year
  $haec_mensis = $d.month

  showTempus $d
  print_wod
  (1.. $haec_uno_dies).each {
    printf "   "
  }
  (1..days_in_month($haec_mensis.to_i, $haec_annus.to_i)).each { |dies|
    diesprop = DateTime.new($haec_annus.to_i,$haec_mensis.to_i,dies)

    if diesprop.wday == 0
      puts
    end

    vdies = dies.to_s
    if (dies < 10)
      vdies = " "+vdies
    end
    if diesprop.day == $d.day
      printf (vdies+" ").cyan.swap
      $striplen += 3
    elsif Controller.hasSchedule $haec_annus, $haec_mensis, dies
      printf (vdies+" ").yellow
      $striplen += 3
    elsif Controller.hasSchedule $haec_annus, $haec_mensis, dies, true
      printf (vdies+" ").gray
      $striplen += 3
    elsif (diesprop.wday == 0) || (diesprop.wday == 6)
      printf (vdies+" ").white
      $striplen += 3
    else
      printf vdies+" "
      $striplen += 3
    end
  }

end

