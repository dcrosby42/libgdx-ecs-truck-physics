require File.expand_path(File.dirname(__FILE__) + "/../lib/ruby/environment") 

require 'math_utils'
require 'title_screen'

def load_texture(img_name)
  file = RELATIVE_ROOT + 'res/images/' + img_name
  handle = Gdx.files.internal(file)
  puts "load_texture: #{handle.path} (exists? #{handle.exists?})"

  begin
    return Texture.new(handle)
  rescue Exception => e
    puts "!! FAIL to load Texture using Gdx.files.internal(#{file.inspect}): #{e.message}\n\t#{e.backtrace.join("\n\t")}"
    raise "Aborting due to textture loading difficulties with #{file}"
  end
end
# libgdx_practice/images/stone1.png

require 'car'
Car.source_dependencies.each do |name|
  require name
end

Thread.abort_on_exception = true

$game_width = 1200
$game_height = 1000

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

$game = MyGame.new
$app = LwjglApplication.new($game, $cfg)

# def get_truck
#   $screen.instance_variable_get(:@entity_manager).get_all_components_of_type(TruckComponent).first
# end
# 
# require 'pry'
# binding.pry

def reload_car
  $app.post_runnable do
    $game.setScreen Car.new
  end
end

reload_car

puts "SLEEPING IN bin/main.rb"
sleep 
puts "EXITING bin/main.rb"
