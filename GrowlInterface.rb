require 'appscript'
include Appscript

#TODO: make sure growl is running
#tell application "System Events"
#	set isRunning to ¬
#		count of (every process whose bundle identifier is "com.Growl.GrowlHelperApp") > 0
#end tell


def notify(appName, title, message, priority=nil, sticky=nil)
  growl = Appscript.app.by_name("GrowlHelperApp")

  growl.register( {:as_application=>appName,
                    :all_notifications=>["not"],
                    :default_notifications=>["not"]})

  growl.notify({
    :application_name=>appName,
    :description=>message,
    :title=>title,
    :with_name=>'not',
    :priority=>priority.nil? ? 0 : priority,
    :sticky=>sticky.nil? ? false : sticky})
end

def n message
  notify "", "", message
end


#notify("app", "title", "msg", 1, true)
