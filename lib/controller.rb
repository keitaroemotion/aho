
class Controller
  def self.getext(isholiday)
    if isholiday
      return "holiday"
    end
    return "data"
  end

  $resource_dir_root = "/usr/local/etc/calx"
  $resource_dir_target = "#{$resource_dir_root}/caldata"


  def self.delete(year, month, day)
    mdir = getMonthDir year, month
    dataf = "#{mdir}/#{day}.data"
    holif = "#{mdir}/#{day}.holiday"
    require 'FileUtils'
    if File.exist? dataf
      FileUtils.rm dataf
    elsif File.exist? holif
      FileUtils.rm holif
    end
  end

  def self.delete_todo(year, month, day, index)
    mdir = getMonthDir year, month
    dataf = "#{mdir}/#{day}.data"
    holif = "#{mdir}/#{day}.holiday"
    file = ""
    require 'FileUtils'
    if File.exist? dataf
      file = dataf
    elsif File.exist? holif
      file = holif
    end
    f = File.open(file, "r")
    datacopied = f.each.to_a
    f.close

    f = File.open(file, "w")
    i = 0
    datacopied.each{ |line|
      if (i == index-1)
      else
        f.puts line
      end
      i += 1
    }
    f.close
  end


  def self.edit(year, month, day, comment, isholiday=false)
    mdir = getMonthDir year, month
    makeDir mdir
    targetfile = "#{mdir}/#{day}.#{getext(isholiday)}"
    #command
  end

  def self.insert(year, month, day, comment, isholiday=false)
    mdir = getMonthDir year, month
    makeDir mdir
    f = File.open("#{mdir}/#{day}.#{getext(isholiday)}", "a")
    f.puts comment
    f.close
  end

  $custom_dir = "%s/custom" % [$resource_dir_target]

  def self.insert_custom(wod, msg)
    if !["su","mo","tu","we","th","fr","sa"].include? wod
      abort "week of day has to be 'su''mo''tu''we''th''fr''sa'.".red
    end

    if msg == "" || msg == nil
      abort "Don't forget to enter the message. Fagit.".red
    end
    makeDir $custom_dir
    # ..custom/weekindex/time.cust
    f = File.open("#{$custom_dir}/#{wod}.cust", "a")
    f.puts msg
    f.close
  end

  def self.getCustoms(wod)
    getArray("#{$custom_dir}/#{wod}.cust")
  end

  def self.getArray(file)
    if !File.exist? file
      return Array.new
    end
    f = File.open(file, "r")
    arr = f.to_a
    f.close
    arr
  end

  def self.get_text(year, month, day, isholiday=false)
    mdir = getMonthDir year, month
    makeDir mdir
    targetfile = "#{mdir}/#{day}.#{getext(isholiday)}"
    if !File.exist? targetfile
      return Array.new
    end

    f = File.open(targetfile, "r")
    contents = f.to_a
    f.close
    contents
  end


  def self.hasSchedule(year, month, day, isholiday=false)
    has = true
    file = "%s/%s.%s" % [getMonthDir(year, month), day, getext(isholiday)]
    if (!File.exist?(file))
      has = false
    end
    has
  end


  def self.getMonthDir(year, month)
    "%s/%s/%s" % [$resource_dir_target, year, month]
  end

  def self.makeDir(dir)
    require 'fileutils'
    FileUtils.mkdir_p dir
  end
end


