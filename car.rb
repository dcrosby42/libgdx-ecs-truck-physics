
class Car
  include Screen

  def initialize
  end

  def vec2(x,y)
    Vector2.new(x,y)
  end

  def rad2deg(r)
    r * 180 / Math::PI 
  end

  def show
    return if @broke

    # @input_processor = DebugInputProcessor.new
    @input_processor = MyInputProcessor.new
    Gdx.input.setInputProcessor @input_processor

    @physics_component = PhysicsComponent.new
    @world = @physics_component.world

    @physics_system = PhysicsSystem.new

    create_main_camera

    create_ground
    
    create_truck

    @sprite_batch = SpriteBatch.new

    @color2x2 = Texture.new(Gdx.files.internal('images/color2x2.png'))
    @chassis = Texture.new(Gdx.files.internal('images/truck_chassis.png'))
    @tire = Texture.new(Gdx.files.internal('images/truck_tire.png'))

    @shape_renderer = ShapeRenderer.new

    @wheel1_rend = make_renderable(texture: @tire, texture_scale: 0.022)
    @wheel2_rend = make_renderable(texture: @tire, texture_scale: 0.022)
    @truck_body_rend = make_renderable(texture: @chassis, texture_scale: 0.022, offset_x: -0.15, offset_y: 0.75)

    create_hud_camera
    @hud_batch = SpriteBatch.new
    @font = BitmapFont.new

  rescue Exception => e
    debug_exception e
    @broke = true
  end

  def create_main_camera
    # CAMERA
    @camera = OrthographicCamera.new
    @zoom_factor = 35
    # @camera.viewportWidth = $game_width * 1.0 / 35
    # @camera.viewportHeight = $game_height * 1.0 / 35
    # @camera.viewportWidth = $game_width
    # @camera.viewportHeight = $game_height
    @look_at = vec2(@camera.viewportWidth * 0.5, @camera.viewportHeight * 0.5)
    # @camera.position.set(@camera.viewportWidth * 0.5, @camera.viewportHeight * 0.5, 0)
  end

  def create_hud_camera
    @hud_camera = OrthographicCamera.new
    @hud_camera.viewportWidth = $game_width
    @hud_camera.viewportHeight = $game_height
    @hud_camera.position.set(@hud_camera.viewportWidth * 0.5, @hud_camera.viewportHeight * 0.5, 0)
    @hud_camera.update
  end

  def create_ground
    # GROUND
    ground_def = BodyDef.new
    ground_def.position.set(0,0.5)
    @ground = @world.createBody(ground_def)

    poly = PolygonShape.new
    poly.setAsBox(50, 0.5)
    box_def = FixtureDef.new
    box_def.shape = poly
    box_def.friction = 1
    box_def.density = 0
    @ground.createFixture(box_def)

    poly.setAsBox(1, 2, vec2(-50, 0.5), 0)
    @ground.createFixture(box_def)

    poly.setAsBox(1, 2, vec2(50, 0.5), 0)
    @ground.createFixture(box_def)
    
    poly.setAsBox(3, 0.5, vec2(5, 1.5), Math::PI / 4)
    @ground.createFixture(box_def)
 
    poly.setAsBox(3, 0.5, vec2(3.5, 1), Math::PI / 8)
    @ground.createFixture(box_def)
 
    poly.setAsBox(3, 0.5, vec2(9, 1.5), -Math::PI / 4)
    @ground.createFixture(box_def)
 
    poly.setAsBox(3, 0.5, vec2(10.5, 1), -Math::PI / 8)
    @ground.createFixture(box_def)

    @ground.reset_mass_data
  end

  def create_truck
    @truck_body_x = 10
    @truck_body_y = 6
    body_def = BodyDef.new
    body_def.type = BodyDef::BodyType::DynamicBody  
    body_def.position.set(@truck_body_x, @truck_body_y)
    @truck_body = @world.createBody(body_def)
 
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

    @truck_body.createFixture(box_def)

    @truck_body.reset_mass_data
 
 
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
    wheel_def.position.set(@truck_body_x - 2, @truck_body_y - 0.6)

    @wheel1 = @world.create_body(wheel_def)
    @wheel1.create_fixture(circle_def)
    @wheel1.reset_mass_data

    wheel_def.position.set(@truck_body_x + 2, @truck_body_y - 0.6)
    @wheel2 = @world.create_body(wheel_def)
    @wheel2.create_fixture(circle_def)
    @wheel2.reset_mass_data

    jd = WheelJointDef.new
    jd.initialize__method(@truck_body, @wheel1, @wheel1.world_center, vec2(0,1.0))
    jd.motorSpeed = 0
    jd.maxMotorTorque = 20.0
    jd.enableMotor = true
    jd.frequencyHz = 50
    jd.dampingRatio = 5
    @motor1 = @world.create_joint(jd)

    jd.initialize__method(@truck_body, @wheel2, @wheel2.world_center, vec2(0,1.0))
    @motor2 = @world.create_joint(jd)
  end


  # One of the API methods
  def hide
    # puts "hide()"
  end

  def update_camera
    if @input_processor.key_down?(Input::Keys::W)
      @zoom_factor += 1
      @zoom_factor = 1 if @zoom_factor < 1
    end
    if @input_processor.key_down?(Input::Keys::S)
      @zoom_factor -= 1
    end

    @camera.viewportWidth = $game_width * 1.0 / @zoom_factor
    @camera.viewportHeight = $game_height * 1.0 / @zoom_factor
    
    # Keyboard control of camera:
    if Gdx.input.isKeyPressed(Input::Keys::A)
      @look_at.x -= 0.2
      @manual_camera = true
    end
    if Gdx.input.isKeyPressed(Input::Keys::D)
      @look_at.x += 0.2 
      @manual_camera = true
    end

    # Camera follows vehicle
    unless @manual_camera
      @look_at.x = @truck_body.position.x
      @look_at.y = @truck_body.position.y + 7
    end

    @camera.position.set(@look_at.x, @look_at.y, 0)
    @camera.update
  end

  def render(delta)
    update_everything delta
    draw_everything
  end

  def update_everything(delta)
    # Level / reload control:
    reload_car if @input_processor.key_pressed?(Input::Keys::BACKSLASH)
    Gdx.app.exit if @input_processor.key_pressed?(Input::Keys::ESCAPE)
    return if @broke


    update_truck
    
    update_camera

    @physics_system.tick(delta, @physics_component)

    @input_processor.clear

  rescue Exception => e
    debug_exception e
    @broke = true
  end

  def update_truck
    power = 0
    if @input_processor.key_down?(Input::Keys::LEFT)
      @manual_camera = false
      power = 100
    elsif @input_processor.key_down?(Input::Keys::RIGHT)
      @manual_camera = false
      power = -100
    end

    if @motor1
      @motor1.set_motor_speed(power)
      # @motor1.set_max_motor_torque(max_torque)
    end
 
    if @motor2
      @motor2.set_motor_speed(power)
      # @motor2.set_max_motor_torque(max_torque)
    end

    @truck_body.apply_torque(0.3*power)
  end

  def draw_everything
    Gdx.gl.glClear(GL10::GL_COLOR_BUFFER_BIT);  

    @sprite_batch.setProjectionMatrix(@camera.combined)
    @sprite_batch.begin

    if true
      update_renderable @wheel1_rend, @wheel1
      update_renderable @wheel2_rend, @wheel2
      update_renderable @truck_body_rend, @truck_body

      draw_renderable @sprite_batch, @wheel1_rend
      draw_renderable @sprite_batch, @wheel2_rend
      draw_renderable @sprite_batch, @truck_body_rend
    end

    @sprite_batch.end

    if @physics_component.do_debug_render
      @physics_component.debug_renderer.render(@physics_component.world, @camera.combined) if @physics_component.do_debug_render
    end

    @hud_batch.setProjectionMatrix(@hud_camera.combined)
    @hud_batch.begin
    @font.draw(@hud_batch, "P -> Play, Q -> Quit", 8, 20);
    @hud_batch.end

    # Drawing shapes using GL utils:
    # @shape_renderer.setProjectionMatrix(@camera.combined)
    # @shape_renderer.begin(ShapeRenderer::ShapeType::Line)
    # @shape_renderer.setColor(1, 0, 0, 1);
    # @shape_renderer.line(0,0, 20,20);
    # @shape_renderer.end

  rescue Exception => e
    debug_exception e
    @broke = true
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
  end

  def make_renderable(opts={})
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

  def update_renderable(r, body)
    r.x = body.position.x - r.center_x
    r.y = body.position.y - r.center_y
    r.angle_degrees = rad2deg(body.angle)
    r
  end

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
        physics_component.position_iterations) 

    end
  end
end

