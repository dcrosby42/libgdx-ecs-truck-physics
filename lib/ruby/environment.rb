lib_ruby_dir = File.expand_path(File.dirname(__FILE__))         # lib/ruby/
lib_dir      = File.expand_path(File.dirname(__FILE__) + "/..") # lib/

$LOAD_PATH.push lib_dir
$LOAD_PATH.push lib_ruby_dir
# $:.push File.expand_path('../../lib/', __FILE__)
# $:.push File.expand_path('../../lib/ruby/', __FILE__)

# Need a different root when inside the jar, luckily $0 is "<script>" in that case
RELATIVE_ROOT = $0['<'] ? 'libgdx_practice/' : ''

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
import com.badlogic.gdx.graphics.Color  
import com.badlogic.gdx.graphics.OrthographicCamera  
import com.badlogic.gdx.math.Vector2  
import com.badlogic.gdx.physics.box2d.Body  
import com.badlogic.gdx.physics.box2d.BodyDef  
import com.badlogic.gdx.physics.box2d.Box2DDebugRenderer  
import com.badlogic.gdx.physics.box2d.CircleShape  
import com.badlogic.gdx.physics.box2d.ChainShape  
import com.badlogic.gdx.physics.box2d.Fixture  
import com.badlogic.gdx.physics.box2d.FixtureDef  
import com.badlogic.gdx.physics.box2d.PolygonShape  
import com.badlogic.gdx.physics.box2d.World  

import com.badlogic.gdx.Input
import com.badlogic.gdx.InputProcessor
import com.badlogic.gdx.InputAdapter

import com.badlogic.gdx.backends.lwjgl.LwjglApplication
import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration

import com.badlogic.gdx.physics.box2d.joints.PrismaticJointDef  
import com.badlogic.gdx.physics.box2d.joints.RevoluteJointDef  
import com.badlogic.gdx.physics.box2d.joints.WheelJointDef  


import com.badlogic.gdx.graphics.glutils.ShapeRenderer

import com.badlogic.gdx.graphics.Texture
import com.badlogic.gdx.graphics.g2d.SpriteBatch
import com.badlogic.gdx.graphics.g2d.BitmapFont

require 'metaid'
require 'math_utils'
