require File.expand_path(File.dirname(__FILE__) + "/../lib/ruby/environment") 

require 'math_utils'
require 'car'

$game_width = 1024
$game_height = 720

$cfg = LwjglApplicationConfiguration.new
$cfg.title = "Truck 2"
$cfg.useGL20 = true
$cfg.width = $game_width
$cfg.height = $game_height

class MyGame < Game
  def create
    $screen = Car.new
    self.setScreen($screen)
  end
end

def debug_exception(e)
  puts "EXCEPTION: #{e.message}\n\t#{e.backtrace.join("\n\t")}"
end

def reload_car
  puts "Reload Car! @ #{Time.now}"
  $app.post_runnable do
    begin
      load "lib/ruby/car.rb"
      $screen = Car.new
      $game.set_screen $screen
    rescue Exception => e
      debug_exception e
      # puts "RELOAD FAIL: #{e.message}\n\t#{e.backtrace.join("\n\t")}"
    end
  end
end

$car_source_time = File.stat("lib/ruby/car.rb").mtime
Thread.abort_on_exception = true
Thread.new do
  loop do
    sleep 0.2
    mtime = File.stat("lib/ruby/car.rb").mtime 
    if mtime != $car_source_time
      $car_source_time = mtime
      reload_car
    end
  end
end

$game = MyGame.new
$app = LwjglApplication.new($game, $cfg)

require 'pry'
binding.pry

