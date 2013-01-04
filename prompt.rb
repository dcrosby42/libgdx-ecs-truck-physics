$:.push "./lib"
$:.push "./lib/ruby"


# Need a different root when inside the jar, luckily $0 is "<script>" in that case
RELATIVE_ROOT = $0['<'] ? 'ecs_game/' : ''

require 'java'
require "gdx-backend-lwjgl-natives.jar"
require "gdx-backend-lwjgl.jar"
require "gdx-natives.jar"
require "gdx.jar"

import com.badlogic.gdx.Game
import com.badlogic.gdx.Screen
import com.badlogic.gdx.ApplicationListener  
import com.badlogic.gdx.Gdx  
import com.badlogic.gdx.graphics.GL10  
import com.badlogic.gdx.graphics.OrthographicCamera  
import com.badlogic.gdx.math.Vector2  
import com.badlogic.gdx.physics.box2d.Body  
import com.badlogic.gdx.physics.box2d.BodyDef  
import com.badlogic.gdx.physics.box2d.Box2DDebugRenderer  
import com.badlogic.gdx.physics.box2d.CircleShape  
import com.badlogic.gdx.physics.box2d.Fixture  
import com.badlogic.gdx.physics.box2d.FixtureDef  
import com.badlogic.gdx.physics.box2d.PolygonShape  
import com.badlogic.gdx.physics.box2d.World  

import com.badlogic.gdx.Input

import com.badlogic.gdx.backends.lwjgl.LwjglApplication
import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration

import com.badlogic.gdx.physics.box2d.joints.PrismaticJointDef  
import com.badlogic.gdx.physics.box2d.joints.RevoluteJointDef  

$game_width = 1024
$game_height = 720

$cfg = LwjglApplicationConfiguration.new
$cfg.title = "Practicew"
$cfg.useGL20 = true
$cfg.width = $game_width
$cfg.height = $game_height


# require 'startup_state'
require 'ball'
require 'car'
class MyGame < Game
#   include ApplicationListener
# 
  def create
    $screen = Car.new
    self.setScreen($screen)
  end
# 
#   def increment_game_clock(seconds)
#     @game_clock += (seconds)
#   end
# 
end

def reload_ball
  puts "Reload Ball!"
  $app.post_runnable do
    begin
      load "ball.rb"
      $screen = Ball.new
      $game.set_screen $screen
    rescue Exception => e
      puts "RELOAD FAIL: #{e.message}\n\t#{e.backtrace.join("\n\t")}"
    end
  end
end

def reload_car
  puts "Reload Car! @ #{Time.now}"
  $app.post_runnable do
    begin
      load "car.rb"
      $screen = Car.new
      $game.set_screen $screen
    rescue Exception => e
      puts "RELOAD FAIL: #{e.message}\n\t#{e.backtrace.join("\n\t")}"
    end
  end
end

$car_source_time = File.stat("car.rb").mtime
Thread.abort_on_exception = true
Thread.new do
  loop do
    sleep 0.2
    mtime = File.stat("car.rb").mtime 
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

