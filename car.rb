
class Car
  include Screen

  def show
    return if @broke

    # @input_processor = DebugInputProcessor.new
    @input_processor = MyInputProcessor.new
    Gdx.input.setInputProcessor @input_processor

    #
    # COMPONENTS: 
    #

    @physics_component = PhysicsComponent.new

    @main_viewport = MainViewport.create(game_width: $game_width, game_height: $game_height)

    GroundComponent.create(@physics_component.world)
    
    @truck_component = TruckComponent.create(@physics_component.world)
    @main_viewport.follow_body = @truck_component.truck_body # FIXME

    @hud_viewport = HudViewport.create(game_width: $game_width, game_height: $game_height)

    #
    # SYSTEMS: 
    #
    
    @physics_system = PhysicsSystem.new
    @truck_system = TruckSystem.new
    @body_renderable_system = BodyRenderableSystem.new
    @main_viewport_system = MainViewportSystem.new
    @hud_viewport_system = HudViewportSystem.new
    
    @main_rendering_system = MainRenderingSystem.new
    @physics_debug_rendering_system = PhysicsDebugRenderingSystem.new
    @hud_rendering_system = HudRenderingSystem.new

  rescue Exception => e
    debug_exception e
    @broke = true
  end





  def render(delta)
    # Level / reload control:
    reload_car if @input_processor.key_pressed?(Input::Keys::BACKSLASH)
    Gdx.app.exit if @input_processor.key_pressed?(Input::Keys::ESCAPE)
    return if @broke

    #
    # UPDATING
    #

    @truck_system.tick(delta, @truck_component, @input_processor)
    
    @physics_system.tick(delta, @physics_component)

    @main_viewport_system.tick(delta, @main_viewport, @input_processor)

    @hud_viewport_system.tick(delta, @hud_viewport)

    @body_renderable_system.tick(delta, [
      [@truck_component.wheel1_rend, @truck_component.wheel1],
      [@truck_component.wheel2_rend, @truck_component.wheel2],
      [@truck_component.truck_body_rend, @truck_component.truck_body],
    ])

    @input_processor.clear

    #
    # RENDERING
    #

    Gdx.gl.glClear(GL10::GL_COLOR_BUFFER_BIT);  

    @main_rendering_system.tick(delta, @main_viewport, [
      @truck_component.wheel1_rend,
      @truck_component.wheel2_rend,
      @truck_component.truck_body_rend,
    ])

    @physics_debug_rendering_system.tick delta, @physics_component, @main_viewport

    @hud_rendering_system.tick(delta, @hud_viewport)

  rescue Exception => e
    debug_exception e
    @broke = true
  end

  def hide
  end

  def resize(w,h)
  end

  def pause
  end

  def resume
  end

  def dispose
  end

  class Renderable 
    attr_accessor :texture,
      :texture_scale,
      :center_x, :center_y,
      :offset_x, :offset_y,
      :x, :y,
      :origin_x, :origin_y,
      :width, :height,
      :scale_x, :scale_y,
      :angle_degrees,
      :source_x, :source_y,
      :source_width, :source_height,
      :flip_x, :flip_y

    def self.create(opts={})
      r = Renderable.new
      r.texture = opts[:texture] || raise("Texture required")
      texture_scale = opts[:texture_scale] || 1.0
      r.width = texture_scale * r.texture.width
      r.height = texture_scale * r.texture.height
      r.center_x = r.width / 2.0 - (opts[:offset_x] || 0.0)
      r.center_y = r.height / 2.0 - (opts[:offset_y] || 0.0)
      r.x = 0
      r.y = 0
      r.origin_x = r.center_x
      r.origin_y = r.center_y
      r.scale_x = 1.0
      r.scale_y = 1.0
      r.angle_degrees = 0
      r.source_x = 0
      r.source_y = 0
      r.source_width = r.texture.width
      r.source_height = r.texture.height
      r.flip_x = false
      r.flip_y = false
      r
    end
  end

  class MyInputProcessor < InputAdapter
    attr_reader :keys_down, :keys_up, :keys_typed

    def initialize
      @keys_down = []
      @keys_up = []
      @keys_typed = []
      clear
    end

    def clear
      @keys_down.clear
      @keys_up.clear
      @keys_typed.clear
    end

    def keyDown(keycode)
      @keys_down << keycode
      true
    end

    def keyUp(keycode)
      @keys_up << keycode
      true
    end

    def keyTyped(char)
      @keys_typed << char
      true
    end

    def key_pressed?(keycode)
      @keys_down.include?(keycode)
    end

    def key_released?(keycode)
      @keys_up.include?(keycode)
    end

    def key_down?(keycode)
      Gdx.input.isKeyPressed keycode
    end
  end

  class ControlState
    attr_accessor :toggle_hud
  end

  class DebugInputProcessor
    include InputProcessor

    def keyDown(keycode)
      debug "keyDown #{keycode}"
      true
    end

    def keyUp(keycode)
      debug "keyUp #{keycode}"
      true
    end

    def keyTyped(char)
      str = ""
      str << char
      debug "keyTyped #{char.inspect} => #{str.inspect}"
      true
    end

    def mouseMoved(x,y)
      debug "mouseMoved #{x},#{y}"
      false
    end

    def touchDown(x,y,pointer,button)
      debug "touchDown #{x},#{y} pointer=#{pointer.inspect} button=#{button.inspect}"
      false
    end

    def touchUp(x,y,pointer,button)
      debug "touchUp #{x},#{y} pointer=#{pointer.inspect} button=#{button.inspect}"
      false
    end

    def touchDragged(x,y,pointer)
      debug "touchDragged #{x},#{y} pointer=#{pointer.inspect}"
      false
    end

    def scrolled(amount)
      debug "scrolled #{amount}"
      false
    end

    private
    def debug(str)
      puts "DebugInputProcessor: #{str}"
    end
  end

  class PhysicsComponent
    attr_accessor :world, :step, :velocity_iterations, :position_iterations,
                  :debug_renderer, :do_debug_render

    def initialize(opts={})
      @step = 1.0/60  
      @velocity_iterations = 30
      @position_iterations = 30

      gravity = Vector2.new(0,-10)
      do_sleep = true # performance improve: don't simulate resting bodies
      @world = World.new(gravity, do_sleep)

      @debug_renderer = Box2DDebugRenderer.new
      @debug_renderer.setDrawAABBs(false)
      # @debug_renderer.draw_aab_bs = true
      @debug_renderer.draw_bodies = true
      @debug_renderer.draw_inactive_bodies = true

      @do_debug_render = opts[:render_debug] || true
    end
  end

  class PhysicsSystem
    def tick(delta, physics_component)
      physics_component.world.step(
        physics_component.step, 
        physics_component.velocity_iterations, 
        physics_component.position_iterations
      ) 
    end
  end

  class MainViewport
    extend MathUtils
    attr_accessor :camera, :follow_body, :look_at, :zoom_factor, :manual_camera, :sprite_batch, :game_height, :game_width

    def self.create(opts={})
      mv = MainViewport.new
      mv.camera = OrthographicCamera.new
      mv.zoom_factor = 35
      mv.look_at = vec2(0,0)
      mv.manual_camera = false
      mv.sprite_batch = SpriteBatch.new
      mv.game_width = opts[:game_width] || raise(":game_width required")
      mv.game_height = opts[:game_height] || raise(":game_height required")
      mv
    end
  end

  class HudViewport
    attr_accessor :camera, :sprite_batch, :font, :game_height, :game_width

    def self.create(opts={})
      hv = HudViewport.new
      hv.camera = OrthographicCamera.new
      hv.game_width = opts[:game_width] || raise(":game_width required")
      hv.game_height = opts[:game_height] || raise(":game_height required")
      hv.camera.viewportWidth = hv.game_width
      hv.camera.viewportHeight = hv.game_height
      hv.camera.position.set(hv.camera.viewportWidth * 0.5, hv.camera.viewportHeight * 0.5, 0)
      hv.camera.update

      hv.sprite_batch = SpriteBatch.new
      hv.font = BitmapFont.new
      hv
    end
  end

  class TruckComponent
    extend MathUtils
    attr_accessor :truck_body, :wheel1, :wheel2, :motor1, :motor2, :truck_body_rend, :wheel1_rend, :wheel2_rend

    def self.create(world)
      truck_body_x = 10
      truck_body_y = 6
      body_def = BodyDef.new
      body_def.type = BodyDef::BodyType::DynamicBody  
      body_def.position.set(truck_body_x, truck_body_y)
      truck_body = world.createBody(body_def)
   
      box_def = FixtureDef.new
      box_def.shape = PolygonShape.new
      box_def.friction = 0.5
      box_def.density = 2
      box_def.restitution = 0.2
      box_def.filter.groupIndex = -1

      box_def.shape.set([
                        vec2(3,1),
                        vec2(-3,1),
                        vec2(-3,0.7),
                        vec2(-1.5,0.7),
                        vec2(-1,0.0),
                        vec2(1,0.0),
                        vec2(1.5,0.7),
                        vec2(3,0.7),
      ].to_java(Vector2))

      truck_body.createFixture(box_def)

      truck_body.reset_mass_data
   
   
      circle_def = FixtureDef.new
      circle_def.shape = CircleShape.new
      circle_def.shape.radius = 0.9
      circle_def.friction = 5
      circle_def.density = 0.1
      circle_def.restitution = 0.2
      circle_def.filter.groupIndex = -1
   
      wheel_def = BodyDef.new
      wheel_def.type = BodyDef::BodyType::DynamicBody
      wheel_def.allowSleep = false 
      wheel_def.position.set(truck_body_x - 2, truck_body_y - 0.6)

      wheel1 = world.create_body(wheel_def)
      wheel1.create_fixture(circle_def)
      wheel1.reset_mass_data

      wheel_def.position.set(truck_body_x + 2, truck_body_y - 0.6)
      wheel2 = world.create_body(wheel_def)
      wheel2.create_fixture(circle_def)
      wheel2.reset_mass_data

      jd = WheelJointDef.new
      jd.initialize__method(truck_body, wheel1, wheel1.world_center, vec2(0,1.0))
      jd.motorSpeed = 0
      jd.maxMotorTorque = 20.0
      jd.enableMotor = true
      jd.frequencyHz = 50
      jd.dampingRatio = 5
      motor1 = world.create_joint(jd)

      jd.initialize__method(truck_body, wheel2, wheel2.world_center, vec2(0,1.0))
      motor2 = world.create_joint(jd)

      # renderabl estuff
      chassis = Texture.new(Gdx.files.internal('images/truck_chassis.png'))
      truck_body_rend = Renderable.create(texture: chassis, texture_scale: 0.022, offset_x: -0.15, offset_y: 0.75)

      tire = Texture.new(Gdx.files.internal('images/truck_tire.png'))
      wheel1_rend = Renderable.create(texture: tire, texture_scale: 0.022)
      wheel2_rend = Renderable.create(texture: tire, texture_scale: 0.022)

      tc = TruckComponent.new
      tc.truck_body = truck_body
      tc.wheel1 = wheel1
      tc.wheel2 = wheel2
      tc.motor1 = motor1
      tc.motor2 = motor2
      tc.truck_body_rend = truck_body_rend
      tc.wheel1_rend = wheel1_rend
      tc.wheel2_rend = wheel2_rend
      tc
    end
  end

  class TruckSystem

    def tick(delta, truck_component, input_processor)
      power = 0
      if input_processor.key_down?(Input::Keys::LEFT)
        power = 100
      elsif input_processor.key_down?(Input::Keys::RIGHT)
        power = -100
      end

      truck_component.motor1.set_motor_speed(power)
      # @motor1.set_max_motor_torque(max_torque)
      truck_component.motor2.set_motor_speed(power)
      # @motor2.set_max_motor_torque(max_torque)
      truck_component.truck_body.apply_torque(0.3*power)
    end
  end

  class BodyRenderableSystem
    include MathUtils
    def tick(delta, rend_body_pairs)
      rend_body_pairs.each do |(r, body)|
        r.x = body.position.x - r.center_x
        r.y = body.position.y - r.center_y
        r.angle_degrees = rad2deg(body.angle)
      end
    end
  end

  class MainRenderingSystem
    def tick(delta, main_viewport, renderables)
      batch = main_viewport.sprite_batch
      batch.setProjectionMatrix(main_viewport.camera.combined)
      batch.begin
      renderables.each do |r|
        draw_renderable batch, r
      end
      batch.end
    end

    private
    def draw_renderable(sprite_batch, r)
      sprite_batch.draw(
        r.texture,
        r.x, r.y,
        r.origin_x, r.origin_y,
        r.width, r.height,
        r.scale_x, r.scale_y,
        r.angle_degrees,
        r.source_x, r.source_y,
        r.source_width, r.source_height,
        r.flip_x, r.flip_y
      )
      r
    end
  end

  class MainViewportSystem
    def tick(delta, main_viewport, input_processor)
      mv = main_viewport
      if input_processor.key_down?(Input::Keys::W)
        mv.zoom_factor += 1
        mv.zoom_factor = 1 if mv.zoom_factor < 1
      end
      if input_processor.key_down?(Input::Keys::S)
        mv.zoom_factor -= 1
      end
      if input_processor.key_down?(Input::Keys::LEFT) or input_processor.key_down?(Input::Keys::RIGHT)
        mv.manual_camera = false
      end

      mv.camera.viewportWidth = mv.game_width * 1.0 / mv.zoom_factor
      mv.camera.viewportHeight = mv.game_height * 1.0 / mv.zoom_factor
      
      # Keyboard control of camera:
      if Gdx.input.isKeyPressed(Input::Keys::A)
        mv.look_at.x -= 0.2
        mv.manual_camera = true
      end
      if Gdx.input.isKeyPressed(Input::Keys::D)
        mv.look_at.x += 0.2 
        mv.manual_camera = true
      end

      # Camera follows vehicle
      if !mv.manual_camera and !mv.follow_body.nil?
        mv.look_at.x = mv.follow_body.position.x
        mv.look_at.y = mv.follow_body.position.y + 7
      end

      mv.camera.position.set(mv.look_at.x, mv.look_at.y, 0)
      mv.camera.update
    end
  end
  
  class HudViewportSystem
    def tick(delta, hud_viewport)
      hud_viewport.camera.update
    end
  end

  class PhysicsDebugRenderingSystem
    def tick(delta, physics_component, main_viewport)
      if physics_component.do_debug_render
        physics_component.debug_renderer.render(physics_component.world, main_viewport.camera.combined) 
      end
    end
  end

  class HudRenderingSystem
    def tick(delta, hud_viewport)
      hv = hud_viewport
      hv.sprite_batch.setProjectionMatrix(hv.camera.combined)
      hv.sprite_batch.begin
      hv.font.draw(hv.sprite_batch, "Drive: Left/Right.  Zoom: W/S.  Pan: A/D.  Reload: \\", 8, 20);
      hv.sprite_batch.end

      # Drawing shapes using GL utils:
      # @shape_renderer.setProjectionMatrix(@camera.combined)
      # @shape_renderer.begin(ShapeRenderer::ShapeType::Line)
      # @shape_renderer.setColor(1, 0, 0, 1);
      # @shape_renderer.line(0,0, 20,20);
      # @shape_renderer.end
    end
  end

  class GroundComponent
    extend MathUtils
    attr_accessor :ground

    def self.create(world)
      ground_def = BodyDef.new
      ground_def.position.set(0,0.5)
      ground = world.createBody(ground_def)

      poly = PolygonShape.new
      poly.setAsBox(50, 0.5)
      box_def = FixtureDef.new
      box_def.shape = poly
      box_def.friction = 1
      box_def.density = 0
      ground.createFixture(box_def)

      poly.setAsBox(1, 2, vec2(-50, 0.5), 0)
      ground.createFixture(box_def)

      poly.setAsBox(1, 2, vec2(50, 0.5), 0)
      ground.createFixture(box_def)
      
      poly.setAsBox(3, 0.5, vec2(5, 1.5), Math::PI / 4)
      ground.createFixture(box_def)
   
      poly.setAsBox(3, 0.5, vec2(3.5, 1), Math::PI / 8)
      ground.createFixture(box_def)
   
      poly.setAsBox(3, 0.5, vec2(9, 1.5), -Math::PI / 4)
      ground.createFixture(box_def)
   
      poly.setAsBox(3, 0.5, vec2(10.5, 1), -Math::PI / 8)
      ground.createFixture(box_def)

      ground.reset_mass_data

      gc = GroundComponent.new
      gc.ground = ground
      gc
    end

  end
end



