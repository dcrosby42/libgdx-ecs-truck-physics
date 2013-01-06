require File.expand_path(File.dirname(__FILE__) + "/../lib/ruby/environment") 

require 'math_utils'
require 'title_screen'

$game_width = 1024
$game_height = 720

$cfg = LwjglApplicationConfiguration.new
$cfg.title = "Truck 2"
$cfg.useGL20 = true
$cfg.width = $game_width
$cfg.height = $game_height

class MyGame < Game
  def create
    $screen = TitleScreen.new
    self.setScreen($screen)
  end
end

def debug_exception(e)
  puts "EXCEPTION: #{e.message}\n\t#{e.backtrace.join("\n\t")}"
end

def load_source(name)
  # puts "load_source #{name}"
  fname = lookup_source(name)
  $watcher.watch_for_mods fname
  load fname
end

def lookup_source(name)
  fname = "lib/ruby/#{name}.rb"
  if File.exists?(fname)
    fname
  else
    raise("Can't see source file #{fname}")
  end
end

def reload_car
  puts "Reload Car! @ #{Time.now}"
  $app.post_runnable do
    begin
      load_source("car")
      Car.source_dependencies.each do |dep|
        load_source(dep)
      end
      $screen = Car.new
      $game.set_screen $screen
    rescue Exception => e
      debug_exception e
      # puts "RELOAD FAIL: #{e.message}\n\t#{e.backtrace.join("\n\t")}"
    end
  end
end

require 'file_watcher'
$watcher = FileWatcher.new
$watcher.on_file_changed do |fname|
  puts "Change to #{fname}"
  reload_car
end
$watcher.run



$game = MyGame.new
$app = LwjglApplication.new($game, $cfg)

reload_car

def get_truck
  $screen.instance_variable_get(:@entity_manager).get_all_components_of_type(TruckComponent).first
end

require 'pry'
binding.pry


