$MyDir = File.expand_path File.dirname(__FILE__)
require File.join $MyDir, 'GrowlInterface'

$Se = Appscript.app.by_name("System Events")
$KeyLeft=123
$KeyReturn=36
$KeyDelete=51

def timeThis(method=nil, *args)
  beginning_time = Time.now
  if block_given?
    yield
  else
    self.send(method, args)
  end
  end_time = Time.now
  puts "Time elapsed #{(end_time - beginning_time).to_i} sec"
end

def uiManip (method=nil, *args)
  n 'Hands off!'
  if block_given?
    yield
  else
    self.send(method, args)
  end
  n 'At ease'
end

def sleepp sec
  print "sleepp "+sec.to_s
  sleep sec
  print " done\n"
end

def getAppId path
  OSAX.osax.info_for(MacTypes::Alias.path(path))[:bundle_identifier]
end

def selectInFileChooser inputPath

  srcDirName, srcFileName, extention = breakUpPath inputPath
  $Se.keystroke('g', :using => [:command_down, :shift_down])
  sleep(0.1)
  $Se.key_code($KeyDelete)
  sleep(0.1)
  srcDirName.reverse.each_char do |c|
    $Se.keystroke c
    sleep 0.01
    $Se.key_code($KeyLeft)
    sleep 0.01
  end

  $Se.key_code($KeyReturn)
  sleep 5
  $Se.keystroke(srcFileName+'.'+extention)
  sleep 3
  $Se.key_code($KeyReturn)

end

def exceptionToS e
    "\n-------------\nError: "+ e.message.strip + "\n" + e.backtrace.join("\n")+"\n-----\n"
end

  def breakUpPath inputPath
		lastSlash = inputPath.rindex("/")
		lastPoint = inputPath.rindex(".")
		srcDirName=inputPath[0..lastSlash]
		srcFileName=inputPath[lastSlash+1..lastPoint-1]
		extention=inputPath[lastPoint+1..inputPath.length]
		[srcDirName, srcFileName, extention]
  end