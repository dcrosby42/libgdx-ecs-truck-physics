require File.expand_path(File.dirname(__FILE__) + "/../lib/ruby/environment") 
require 'app_shell'


app_shell = AppShell.new
app_shell.launch_game!
app_shell.prompt
