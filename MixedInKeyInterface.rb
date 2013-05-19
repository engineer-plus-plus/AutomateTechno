#!/usr/bin/env ruby
$MyDir = File.expand_path File.dirname(__FILE__)
require File.join $MyDir, 'GrowlInterface'
require File.join $MyDir, 'ToolBox'
require 'osax'
include OSAX
require 'appscript'
include Appscript


class MixedInKeyInterface
  @@MikDirect = Appscript.app.by_id("com.mixedinkey.application")


  def self.process fullFName
    raise sprintf "File >>%s<< doesn't exit", fullFName if not File.exist? fullFName
    puts "activate mik"
    if @@MikDirect.is_running?
      @@MikDirect.activate
    else
      @@MikDirect.activate
      sleep 20
    end
    @MikWin=$Se.processes["Mixed In Key 5"].windows[1]

    puts "click on Analize Songs"
    @MikWin.scroll_areas[1].UI_elements[1].UI_elements["Switch to the analyze panel"].click
    sleep 0.1

    uiManip{
      puts "clear all if needed"
      clearAllIfNeeded
      sleep(0.5)
      puts "click add files"
      @MikWin.groups[1].buttons[5].click
      selectInFileChooser fullFName
    }
  end

  def self.clearAllIfNeeded
    #click on the first row to select it
    if @MikWin.groups[1].scroll_areas[1].tables[1].rows.count > 0
      @MikWin.groups[1].scroll_areas[1].tables[1].rows[1].text_fields[0].confirm
      sleep(0.1)
      $Se.key_code($KeyReturn)
      sleep(0.1)
      $Se.keystroke('a', :using => [:command_down])
      sleep(0.1)
      $Se.key_code($KeyDelete)
      sleep(0.1)
    end
  end
end   #  MixedInKeyInterface

begin
    MixedInKeyInterface.process ARGV[0]
rescue Exception=>e
  notify('', 'Processing failed', ARGV[0]+"\n"+ exceptionToS(e), 3, true )
  raise e
end
