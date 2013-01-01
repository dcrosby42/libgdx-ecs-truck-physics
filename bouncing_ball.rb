# $:.push File.expand_path('../../lib/', __FILE__)
# $:.push File.expand_path('../../lib/ruby/', __FILE__)
$:.push "./lib"
$:.push "./lib/ruby"

# Need a different root when inside the jar, luckily $0 is "<script>" in that case
RELATIVE_ROOT = $0['<'] ? 'ecs_game/' : ''

require 'java'
require "gdx-backend-lwjgl-natives.jar"
require "gdx-backend-lwjgl.jar"
require "gdx-natives.jar"
require "gdx.jar"

import com.badlogic.gdx.ApplicationListener  
import com.badlogic.gdx.Gdx  
import com.badlogic.gdx.graphics.GL10  
import com.badlogic.gdx.graphics.OrthographicCamera  
import com.badlogic.gdx.math.Vector2  
import com.badlogic.gdx.physics.box2d.Body  
import com.badlogic.gdx.physics.box2d.BodyDef  
# import com.badlogic.gdx.physics.box2d.BodyDef.BodyType  
import com.badlogic.gdx.physics.box2d.Box2DDebugRenderer  
import com.badlogic.gdx.physics.box2d.CircleShape  
import com.badlogic.gdx.physics.box2d.Fixture  
import com.badlogic.gdx.physics.box2d.FixtureDef  
import com.badlogic.gdx.physics.box2d.PolygonShape  
import com.badlogic.gdx.physics.box2d.World  

java_import com.badlogic.gdx.Input

java_import com.badlogic.gdx.backends.lwjgl.LwjglApplication
java_import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration

$game_width = 1024
$game_height = 720


class PhysicsDemo
  include ApplicationListener

  BOX_STEP = 1.0/60  
  BOX_VELOCITY_ITERATIONS = 6  
  BOX_POSITION_ITERATIONS = 2  
  WORLD_TO_BOX = 0.01
  BOX_WORLD_TO = 100  

  def create
    @world = World.new(Vector2.new(0,-100), true)
    @debug_renderer = Box2DDebugRenderer.new
    @camera = OrthographicCamera.new
    @camera.viewportWidth = $game_width
    @camera.viewportHeight = $game_height
    @camera.position.set(@camera.viewportWidth * 0.5, @camera.viewportHeight * 0.5, 0)
    @camera.update

    #Ground body  
    groundBodyDef = BodyDef.new
    groundBodyDef.position.set(Vector2.new(0, 10))  
    groundBody = @world.createBody(groundBodyDef)  
    groundBox = PolygonShape.new
    groundBox.setAsBox((@camera.viewportWidth) * 2, 10.0)  
    groundBody.createFixture(groundBox, 0.0)  

    #Dynamic Body  
    bodyDef = BodyDef.new
    bodyDef.type = BodyDef::BodyType::DynamicBody  
    bodyDef.position.set(@camera.viewportWidth / 2, @camera.viewportHeight / 2)  
    body = @world.createBody(bodyDef)  
    dynamicCircle = CircleShape.new
    dynamicCircle.setRadius(20)  
    fixtureDef = FixtureDef.new
    fixtureDef.shape = dynamicCircle  
    fixtureDef.density = 1.0
    fixtureDef.friction = 0.0  
    fixtureDef.restitution =0.5 
    body.createFixture(fixtureDef)  
  end

  def dispose
  end

  def render
    
    Gdx.gl.glClear(GL10::GL_COLOR_BUFFER_BIT);  
    @debug_renderer.render(@world, @camera.combined);  
    @world.step(BOX_STEP, BOX_VELOCITY_ITERATIONS, BOX_POSITION_ITERATIONS);  

    if Gdx.input.isKeyPressed(Input::Keys::ESCAPE)
      # @game.setScreen StartupState.new(@game)
      Gdx.app.exit
    end
  end

  def resize(w,h)
  end

  def pause
  end

  def resume
  end

end

cfg = LwjglApplicationConfiguration.new
cfg.title = "Physics Practice"
cfg.useGL20 = true
cfg.width = $game_width
cfg.height = $game_height

$my_game = PhysicsDemo.new
$app = LwjglApplication.new($my_game, cfg)


__END__
 public class PhysicsDemo implements ApplicationListener {  
      World world = new World(new Vector2(0, -100), true);  
      Box2DDebugRenderer debugRenderer;  
      OrthographicCamera camera;  
      static final float BOX_STEP=1/60f;  
      static final int BOX_VELOCITY_ITERATIONS=6;  
      static final int BOX_POSITION_ITERATIONS=2;  
      static final float WORLD_TO_BOX=0.01f;  
      static final float BOX_WORLD_TO=100f;  
      @Override  
      public void create() {            
           camera = new OrthographicCamera();  
           camera.viewportHeight = 320;  
           camera.viewportWidth = 480;  
           camera.position.set(camera.viewportWidth * .5f, camera.viewportHeight * .5f, 0f);  
           camera.update();  
           //Ground body  
           BodyDef groundBodyDef =new BodyDef();  
           groundBodyDef.position.set(new Vector2(0, 10));  
           Body groundBody = world.createBody(groundBodyDef);  
           PolygonShape groundBox = new PolygonShape();  
           groundBox.setAsBox((camera.viewportWidth) * 2, 10.0f);  
           groundBody.createFixture(groundBox, 0.0f);  
           //Dynamic Body  
           BodyDef bodyDef = new BodyDef();  
           bodyDef.type = BodyType.DynamicBody;  
           bodyDef.position.set(camera.viewportWidth / 2, camera.viewportHeight / 2);  
           Body body = world.createBody(bodyDef);  
           CircleShape dynamicCircle = new CircleShape();  
           dynamicCircle.setRadius(5f);  
           FixtureDef fixtureDef = new FixtureDef();  
           fixtureDef.shape = dynamicCircle;  
           fixtureDef.density = 1.0f;  
           fixtureDef.friction = 0.0f;  
           fixtureDef.restitution = 1;  
           body.createFixture(fixtureDef);  
           debugRenderer = new Box2DDebugRenderer();  
      }  
      @Override  
      public void dispose() {  
      }  
      @Override  
      public void render() {            
           Gdx.gl.glClear(GL10.GL_COLOR_BUFFER_BIT);  
           debugRenderer.render(world, camera.combined);  
           world.step(BOX_STEP, BOX_VELOCITY_ITERATIONS, BOX_POSITION_ITERATIONS);  
      }  
      @Override  
      public void resize(int width, int height) {  
      }  
      @Override  
      public void pause() {  
      }  
      @Override  
      public void resume() {  
      }  
 }  
