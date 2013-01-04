
class Car
  include Screen

  def initialize
  end

  def vec2(x,y)
    Vector2.new(x,y)
  end

  def show
    @BOX_STEP = 1.0/60  
    @BOX_VELOCITY_ITERATIONS = 6  
    @BOX_POSITION_ITERATIONS = 2  
    # @WORLD_TO_BOX = 0.01
    # @BOX_WORLD_TO = 100  

    # WORLD
    gravity = Vector2.new(0,-10)
    do_sleep = true # performance improve: don't simulate resting bodies
    @world = World.new(gravity, do_sleep)
    @debug_renderer = Box2DDebugRenderer.new
    @debug_renderer.setDrawAABBs(false)
    # @debug_renderer.draw_aab_bs = true
    @debug_renderer.draw_bodies = true
    @debug_renderer.draw_inactive_bodies = true

    # CAMERA
    @camera = OrthographicCamera.new
    @camera.viewportWidth = $game_width * 1.0 / 25
    @camera.viewportHeight = $game_height * 1.0 / 25
    # @camera.viewportWidth = $game_width
    # @camera.viewportHeight = $game_height
    @camera.position.set(@camera.viewportWidth * 0.5, @camera.viewportHeight * 0.5, 0)
    @camera.update

    # GROUND
    bodyDef = BodyDef.new
    bodyDef.position.set(0,0.5)
    body = @world.createBody(bodyDef)

    poly = PolygonShape.new
    poly.setAsBox(50, 0.5)
    boxDef = FixtureDef.new
    boxDef.shape = poly
    boxDef.friction = 1
    boxDef.density = 0
    body.createFixture(boxDef)

    poly.setAsBox(1, 2, vec2(-50, 0.5), 0)
    body.createFixture(boxDef)

    poly.setAsBox(1, 2, vec2(50, 0.5), 0)
    body.createFixture(boxDef)
    
    poly.setAsBox(3, 0.5, vec2(5, 1.5), Math::PI / 4)
    body.createFixture(boxDef)
 
    poly.setAsBox(3, 0.5, vec2(3.5, 1), Math::PI / 8)
    body.createFixture(boxDef)
 
    poly.setAsBox(3, 0.5, vec2(9, 1.5), -Math::PI / 4)
    body.createFixture(boxDef)
 
    poly.setAsBox(3, 0.5, vec2(10.5, 1), -Math::PI / 8)
    body.createFixture(boxDef)

    body.reset_mass_data
    
    # CART
         # boxDef = new b2PolygonDef();
         # boxDef.density = 2;
         # boxDef.friction = 0.5;
         # boxDef.restitution = 0.2;
         # boxDef.filter.groupIndex = -1;
         # boxDef.SetAsBox(1.5, 0.3);
         # cart.CreateShape(boxDef);
    bodyDef = BodyDef.new
    bodyDef.type = BodyDef::BodyType::DynamicBody  
    # bodyDef.position.set(0, 3.5)
    bodyDef.position.set(20, 3.5)
    @cart = @world.createBody(bodyDef)
 
    boxDef = FixtureDef.new
    boxDef.shape = PolygonShape.new
    boxDef.friction = 0.5
    boxDef.density = 2
    boxDef.restitution = 0.2
    boxDef.filter.groupIndex = -1

    boxDef.shape.setAsBox(1.5, 0.3)
    @cart.createFixture(boxDef)

       # boxDef.SetAsOrientedBox(0.4, 0.15, new b2Vec2(-1, -0.3), Math.PI/3);
       # cart.CreateShape(boxDef);
    boxDef.shape.setAsBox(0.4, 0.15, vec2(-1, -0.3), Math::PI / 3)
    @cart.createFixture(boxDef)
 
         # boxDef.SetAsOrientedBox(0.4, 0.15, new b2Vec2(1, -0.3), -Math.PI/3);
         # cart.CreateShape(boxDef);
    boxDef.shape.setAsBox(0.4, 0.15, vec2(1, -0.3), -Math::PI / 3)
    @cart.createFixture(boxDef)
 
         # cart.SetMassFromShapes();
    body.reset_mass_data
 
         # boxDef.density = 1;
 
    # AXLES
    boxDef.density = 2
         # axle1 = world.CreateBody(bodyDef);
    @axle1 = @world.createBody(bodyDef)
 
         # boxDef.SetAsOrientedBox(0.4, 0.1, new b2Vec2(-1 - 0.6*Math.cos(Math.PI/3), -0.3 - 0.6*Math.sin(Math.PI/3)), Math.PI/3);
    boxDef.shape.setAsBox(0.4, 0.1, vec2(-1 - 0.6 * Math::cos(Math::PI / 3), -0.3 - 0.6 * Math::sin(Math::PI / 3)), Math::PI / 3)
         # axle1.CreateShape(boxDef);
         # axle1.SetMassFromShapes();
    @axle1.createFixture(boxDef) 
    @axle1.reset_mass_data
 
         # prismaticJointDef = new b2PrismaticJointDef();
         # prismaticJointDef.Initialize(cart, axle1, axle1.GetWorldCenter(), new b2Vec2(Math.cos(Math.PI/3), Math.sin(Math.PI/3)));
         # prismaticJointDef.lowerTranslation = -0.3;
         # prismaticJointDef.upperTranslation = 0.5;
         # prismaticJointDef.enableLimit = true;
         # prismaticJointDef.enableMotor = true;
    jd = PrismaticJointDef.new
    jd.initialize__method(@cart, @axle1, @axle1.world_center, vec2(Math::cos(Math::PI / 3), Math::sin(Math::PI / 3)))
    jd.lowerTranslation = -0.3
    jd.upperTranslation = 0.5
    jd.enableLimit = true
    jd.enableMotor = true

         # spring1 = world.CreateJoint(prismaticJointDef) as b2PrismaticJoint;
    @spring1 = @world.createJoint(jd)
 
         # axle2 = world.CreateBody(bodyDef);
    @axle2 = @world.createBody(bodyDef)
 
         # boxDef.SetAsOrientedBox(0.4, 0.1, new b2Vec2(1 + 0.6*Math.cos(-Math.PI/3), -0.3 + 0.6*Math.sin(-Math.PI/3)), -Math.PI/3);
    boxDef.shape.setAsBox(0.4, 0.1, vec2(1 + 0.6*Math::cos(-Math::PI/3), -0.3 + 0.6*Math::sin(-Math::PI/3)), -Math::PI/3)
         # axle2.CreateShape(boxDef);
         # axle2.SetMassFromShapes();
    @axle2.create_fixture boxDef
    @axle2.reset_mass_data
 
         # prismaticJointDef.Initialize(cart, axle2, axle2.GetWorldCenter(), new b2Vec2(-Math.cos(Math.PI/3), Math.sin(Math.PI/3)));
    jd.initialize__method(@cart, @axle2, @axle2.world_center, vec2(-Math::cos(Math::PI / 3), Math::sin(Math::PI / 3)))
 
         # spring2 = world.CreateJoint(prismaticJointDef) as b2PrismaticJoint;
    @spring2 = @world.createJoint(jd)
 
         # // add wheels //
         # circleDef.radius = 0.7;
         # circleDef.density = 0.1;
         # circleDef.friction = 5;
         # circleDef.restitution = 0.2;
         # circleDef.filter.groupIndex = -1;
    circleDef = FixtureDef.new
    circleDef.shape = CircleShape.new
    circleDef.shape.radius = 0.7
    circleDef.friction = 5
    circleDef.density = 0.1
    circleDef.restitution = 0.2
    circleDef.filter.groupIndex = -1
 
         # for (i = 0; i < 2; i++) {
    2.times do |i|
         #    bodyDef = new b2BodyDef();
      bodyDef = BodyDef.new
      bodyDef.type = BodyDef::BodyType::DynamicBody  
         #    if (i == 0) bodyDef.position.Set(axle1.GetWorldCenter().x - 0.3*Math.cos(Math.PI/3), axle1.GetWorldCenter().y - 0.3*Math.sin(Math.PI/3));
      if i == 0
        # bodyDef.position.set(@axle1.world_center.x - 0.3*Math::cos(Math::PI/3), @axle1.world_center.y - 0.3*Math::sin(Math::PI/3))
        axle_center_x = 20 + (-1 - 0.6 * Math::cos(Math::PI / 3))
        axle_center_y = 3.5 + (-0.3 - 0.6 * Math::sin(Math::PI / 3))
        bodyDef.position.set(axle_center_x - 0.3*Math::cos(Math::PI/3), axle_center_y - 0.3*Math::sin(Math::PI/3))
      else
      #    else bodyDef.position.Set(axle2.GetWorldCenter().x + 0.3*Math.cos(-Math.PI/3), axle2.GetWorldCenter().y + 0.3*Math.sin(-Math.PI/3));
        # bodyDef.position.set(@axle2.world_center.x + 0.3*Math::cos(-Math::PI/3), @axle2.world_center.y + 0.3*Math::sin(-Math::PI/3))

    #xxxxxx boxDef.shape.setAsBox(0.4, 0.1, vec2(1 + 0.6*Math::cos(-Math::PI/3), -0.3 + 0.6*Math::sin(-Math::PI/3)), -Math::PI/3)
        axle_center_x = 20 + (1 + 0.6 * Math::cos(-Math::PI / 3))
        axle_center_y = 3.5 + (-0.3 + 0.6 * Math::sin(-Math::PI / 3))
        bodyDef.position.set(axle_center_x + 0.3*Math::cos(Math::PI/3), axle_center_y - 0.3*Math::sin(Math::PI/3))
      end

      #    bodyDef.allowSleep = false;
      bodyDef.allowSleep = false;

      #    if (i == 0) wheel1 = world.CreateBody(bodyDef);
      if i == 0
        @wheel1 = @world.createBody(bodyDef)
        @wheel1.createFixture(circleDef)
      else
      #    else wheel2 = world.CreateBody(bodyDef);
        @wheel2 = @world.createBody(bodyDef)
        @wheel2.createFixture(circleDef)
      end
    end
 
         # // add joints //
         # revoluteJointDef = new b2RevoluteJointDef();
         # revoluteJointDef.enableMotor = true;
    rdef = RevoluteJointDef.new
    rdef.enableMotor = true
         # revoluteJointDef.Initialize(axle1, wheel1, wheel1.GetWorldCenter());
         # motor1 = world.CreateJoint(revoluteJointDef) as b2RevoluteJoint;
    rdef.initialize__method(@axle1, @wheel1, @wheel1.world_center)
    @motor1 = @world.create_joint(rdef)

         # revoluteJointDef.Initialize(axle2, wheel2, wheel2.GetWorldCenter());
         # motor2 = world.CreateJoint(revoluteJointDef) as b2RevoluteJoint;
    rdef.initialize__method(@axle2, @wheel2, @wheel2.world_center)
    @motor2 = @world.create_joint(rdef)
  end

  def hide
  end

  def render(d)
    Gdx.gl.glClear(GL10::GL_COLOR_BUFFER_BIT);  
    @debug_renderer.render(@world, @camera.combined);  
    @world.step(@BOX_STEP, @BOX_VELOCITY_ITERATIONS, @BOX_POSITION_ITERATIONS);  

    if Gdx.input.isKeyPressed(Input::Keys::BACKSLASH)
      reload_car
      # puts "HI!"
      # require 'pry'
      # binding.pry
    end

    if Gdx.input.isKeyPressed(Input::Keys::ESCAPE)
      # Gdx.app.exit
    end

    power = 0
    max_torque = 0.5
    if Gdx.input.isKeyPressed(Input::Keys::LEFT)
      power = 1
      max_torque = 17
    elsif Gdx.input.isKeyPressed(Input::Keys::RIGHT)
      power = -1
      max_torque = 17
    end
 
    @motor1.set_motor_speed(15*Math::PI * power)
    @motor1.set_max_motor_torque(max_torque)
 
    @motor1.set_motor_speed(15*Math::PI * power)
    @motor1.set_max_motor_torque(max_torque)

         # spring1.SetMaxMotorForce(30+Math.abs(800*Math.pow(spring1.GetJointTranslation(), 2)));
         # spring1.SetMotorSpeed((spring1.GetMotorSpeed() - 10*spring1.GetJointTranslation())*0.4);         
    @spring1.set_max_motor_force(30 + (800* (@spring1.get_joint_translation ** 2)).abs)
    @spring1.set_motor_speed((@spring1.get_motor_speed - 10*@spring1.get_joint_translation)*0.4)
 
         # spring2.SetMaxMotorForce(20+Math.abs(800*Math.pow(spring2.GetJointTranslation(), 2)));
         # spring2.SetMotorSpeed(-4*Math.pow(spring2.GetJointTranslation(), 1));
    #
    @spring2.set_max_motor_force(30 + (800* (@spring2.get_joint_translation ** 2)).abs)
    @spring2.set_motor_speed((@spring2.get_motor_speed - 10*@spring2.get_joint_translation)*0.4)
    # @spring2.set_max_motor_force(20 + (800* (@spring2.get_joint_translation ** 2)).abs)
    # @spring2.set_motor_speed(-4*@spring1.get_joint_translation)
 
         # cart.ApplyTorque(30*(input.isPressed(37) ? 1: input.isPressed(39) ? -1 : 0));
    @cart.apply_torque(30 * power)
 
         # screen.x -= (screen.x - (-DRAW_SCALE*cart.GetWorldCenter().x + SCREEN_WIDTH/2 - cart.GetLinearVelocity().x*10))/3;
         # screen.y -= (screen.y - (DRAW_SCALE*cart.GetWorldCenter().y + 2*SCREEN_HEIGHT/3 + cart.GetLinearVelocity().y*6))/3;
 
         # world.Step(TIME_STEP, ITERATIONS);
 
         # FRateLimiter.limitFrame(60);
  end

  def resize(w,h)
  end

  def pause
  end

  def resume
  end

  def dispose
  end

end
__END__
package {
 
   import flash.display.Sprite;
   import flash.events.Event;
 
   import Box2D.Dynamics.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.Joints.*;
 
   public class TruckGame extends Sprite {
 
      public const ITERATIONS      : int       = 30;
      public const TIME_STEP       : Number    = 1.0/60.0;
      public const SCREEN_WIDTH    : int       = 800;
      public const SCREEN_HEIGHT   : int      = 500;
      public const DRAW_SCALE      : Number   = 50;
 
      private var world    : b2World;
      private var cart    : b2Body;
      private var wheel1    : b2Body;
      private var wheel2    : b2Body;
      private var axle1   : b2Body;
      private var axle2   : b2Body;
      private var motor1   : b2RevoluteJoint;
      private var motor2   : b2RevoluteJoint;
      private var spring1   : b2PrismaticJoint;
      private var spring2   : b2PrismaticJoint;
 
      private var screen   : Sprite;
      private var input   : Input;
 
 
      public function TruckGame() : void {
 
         // create the drawing screen //
         screen = new Sprite();
         screen.scaleY = -1;
         screen.y = SCREEN_HEIGHT;
         addChild(screen);
 
         // initialize input object //
         input = new Input(this);
 
         // add main loop event listener //
         addEventListener(Event.ENTER_FRAME, update, false, 0, true);
 
         init();
 
      }
 
      private function init() : void {
 
         // create world //
         var worldAABB:b2AABB = new b2AABB();
 
         worldAABB.lowerBound.Set(-200, -100);
         worldAABB.upperBound.Set(200, 200);
 
         world = new b2World(worldAABB, new b2Vec2(0, -10.0), true);
 
 
         // allow debug drawing //
         var debugDraw : b2DebugDraw = new b2DebugDraw();
         debugDraw.m_sprite          = screen;
         debugDraw.m_drawScale       = DRAW_SCALE;
         debugDraw.m_fillAlpha       = 0.1;
         debugDraw.m_lineThickness    = 2.0;
         debugDraw.m_drawFlags       = 1;
 
         world.SetDebugDraw(debugDraw);
 
 
         // temporary variables for adding new bodies //
         var i               : int;
         var body             : b2Body;
         var bodyDef          : b2BodyDef;
         var boxDef             : b2PolygonDef;
         var circleDef          : b2CircleDef;
         var revoluteJointDef   : b2RevoluteJointDef;
         var prismaticJointDef   : b2PrismaticJointDef;
 
 
         // add the ground //
         bodyDef = new b2BodyDef();
         bodyDef.position.Set(0, 0.5);
 
         boxDef = new b2PolygonDef();
         boxDef.SetAsBox(50, 0.5);
         boxDef.friction = 1;
         boxDef.density = 0; 
 
         body = world.CreateBody(bodyDef);
         body.CreateShape(boxDef);
 
         boxDef.SetAsOrientedBox(1, 2, new b2Vec2(-50, 0.5), 0);
         body.CreateShape(boxDef);
 
         boxDef.SetAsOrientedBox(1, 2, new b2Vec2(50, 0.5), 0);
         body.CreateShape(boxDef);
 
         boxDef.SetAsOrientedBox(3, 0.5, new b2Vec2(5, 1.5), Math.PI/4);
         body.CreateShape(boxDef);
 
         boxDef.SetAsOrientedBox(3, 0.5, new b2Vec2(3.5, 1), Math.PI/8);
         body.CreateShape(boxDef);
 
         boxDef.SetAsOrientedBox(3, 0.5, new b2Vec2(9, 1.5), -Math.PI/4);
         body.CreateShape(boxDef);
 
         boxDef.SetAsOrientedBox(3, 0.5, new b2Vec2(10.5, 1), -Math.PI/8);
         body.CreateShape(boxDef);
 
         body.SetMassFromShapes();
 
 
         // add random shit //
         circleDef = new b2CircleDef();
         circleDef.density = 0.01;
         circleDef.friction = 0.1;
         circleDef.restitution = 0.5;
 
         for (i = 0; i < 30; i++) {
            circleDef.radius = Math.random()/20+0.02;
 
            bodyDef = new b2BodyDef();
            bodyDef.position.Set(Math.random()*35+15, 1);
            bodyDef.allowSleep = true;
            bodyDef.linearDamping = 0.1;
            bodyDef.angularDamping = 0.1;
 
            body = world.CreateBody(bodyDef);
 
            body.CreateShape(circleDef);
            body.SetMassFromShapes();
         }
 
 
         // add cart //
         bodyDef = new b2BodyDef();
         bodyDef.position.Set(0, 3.5);
 
         cart = world.CreateBody(bodyDef);
 
         boxDef = new b2PolygonDef();
         boxDef.density = 2;
         boxDef.friction = 0.5;
         boxDef.restitution = 0.2;
         boxDef.filter.groupIndex = -1;
 
         boxDef.SetAsBox(1.5, 0.3);
         cart.CreateShape(boxDef);
 
         boxDef.SetAsOrientedBox(0.4, 0.15, new b2Vec2(-1, -0.3), Math.PI/3);
         cart.CreateShape(boxDef);
 
         boxDef.SetAsOrientedBox(0.4, 0.15, new b2Vec2(1, -0.3), -Math.PI/3);
         cart.CreateShape(boxDef);
 
         cart.SetMassFromShapes();
 
         boxDef.density = 1;
 
 
         // add the axles //
         axle1 = world.CreateBody(bodyDef);
 
         boxDef.SetAsOrientedBox(0.4, 0.1, new b2Vec2(-1 - 0.6*Math.cos(Math.PI/3), -0.3 - 0.6*Math.sin(Math.PI/3)), Math.PI/3);
         axle1.CreateShape(boxDef);
         axle1.SetMassFromShapes();
 
         prismaticJointDef = new b2PrismaticJointDef();
         prismaticJointDef.Initialize(cart, axle1, axle1.GetWorldCenter(), new b2Vec2(Math.cos(Math.PI/3), Math.sin(Math.PI/3)));
         prismaticJointDef.lowerTranslation = -0.3;
         prismaticJointDef.upperTranslation = 0.5;
         prismaticJointDef.enableLimit = true;
         prismaticJointDef.enableMotor = true;
 
         spring1 = world.CreateJoint(prismaticJointDef) as b2PrismaticJoint;
 
 
         axle2 = world.CreateBody(bodyDef);
 
         boxDef.SetAsOrientedBox(0.4, 0.1, new b2Vec2(1 + 0.6*Math.cos(-Math.PI/3), -0.3 + 0.6*Math.sin(-Math.PI/3)), -Math.PI/3);
         axle2.CreateShape(boxDef);
         axle2.SetMassFromShapes();
 
         prismaticJointDef.Initialize(cart, axle2, axle2.GetWorldCenter(), new b2Vec2(-Math.cos(Math.PI/3), Math.sin(Math.PI/3)));
 
         spring2 = world.CreateJoint(prismaticJointDef) as b2PrismaticJoint;
 
 
         // add wheels //
         circleDef.radius = 0.7;
         circleDef.density = 0.1;
         circleDef.friction = 5;
         circleDef.restitution = 0.2;
         circleDef.filter.groupIndex = -1;
 
         for (i = 0; i < 2; i++) {
 
            bodyDef = new b2BodyDef();
            if (i == 0) bodyDef.position.Set(axle1.GetWorldCenter().x - 0.3*Math.cos(Math.PI/3), axle1.GetWorldCenter().y - 0.3*Math.sin(Math.PI/3));
            else bodyDef.position.Set(axle2.GetWorldCenter().x + 0.3*Math.cos(-Math.PI/3), axle2.GetWorldCenter().y + 0.3*Math.sin(-Math.PI/3));
            bodyDef.allowSleep = false;
 
            if (i == 0) wheel1 = world.CreateBody(bodyDef);
            else wheel2 = world.CreateBody(bodyDef);
 
            (i == 0 ? wheel1 : wheel2).CreateShape(circleDef);
            (i == 0 ? wheel1 : wheel2).SetMassFromShapes();
 
         }
 
 
         // add joints //
         revoluteJointDef = new b2RevoluteJointDef();
         revoluteJointDef.enableMotor = true;
 
         revoluteJointDef.Initialize(axle1, wheel1, wheel1.GetWorldCenter());
         motor1 = world.CreateJoint(revoluteJointDef) as b2RevoluteJoint;
 
         revoluteJointDef.Initialize(axle2, wheel2, wheel2.GetWorldCenter());
         motor2 = world.CreateJoint(revoluteJointDef) as b2RevoluteJoint;
 
      }
 
 
      public function update(e : Event) : void {
 
         if (input.isPressed(32)) {
            world = null;
            init();
            return;
         }
 
         motor1.SetMotorSpeed(15*Math.PI * (input.isPressed(40) ? 1 : input.isPressed(38) ? -1 : 0));
         motor1.SetMaxMotorTorque(input.isPressed(40) || input.isPressed(38) ? 17 : 0.5);
 
         motor2.SetMotorSpeed(15*Math.PI * (input.isPressed(40) ? 1 : input.isPressed(38) ? -1 : 0));
         motor2.SetMaxMotorTorque(input.isPressed(40) || input.isPressed(38) ? 12 : 0.5);
 
         spring1.SetMaxMotorForce(30+Math.abs(800*Math.pow(spring1.GetJointTranslation(), 2)));
         //spring1.SetMotorSpeed(-4*Math.pow(spring1.GetJointTranslation(), 1));
         spring1.SetMotorSpeed((spring1.GetMotorSpeed() - 10*spring1.GetJointTranslation())*0.4);         
 
         spring2.SetMaxMotorForce(20+Math.abs(800*Math.pow(spring2.GetJointTranslation(), 2)));
         spring2.SetMotorSpeed(-4*Math.pow(spring2.GetJointTranslation(), 1));
 
         cart.ApplyTorque(30*(input.isPressed(37) ? 1: input.isPressed(39) ? -1 : 0));
 
         screen.x -= (screen.x - (-DRAW_SCALE*cart.GetWorldCenter().x + SCREEN_WIDTH/2 - cart.GetLinearVelocity().x*10))/3;
         screen.y -= (screen.y - (DRAW_SCALE*cart.GetWorldCenter().y + 2*SCREEN_HEIGHT/3 + cart.GetLinearVelocity().y*6))/3;
 
         world.Step(TIME_STEP, ITERATIONS);
 
         FRateLimiter.limitFrame(60);
 
      }
 
   }
 
}
