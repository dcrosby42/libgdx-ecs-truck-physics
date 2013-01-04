
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
    @BOX_STEP = 1.0/60  
    @BOX_VELOCITY_ITERATIONS = 30
    @BOX_POSITION_ITERATIONS = 30
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

    @do_debug_render = true

    # CAMERA
    @camera = OrthographicCamera.new
    @zoom_factor = 35
    # @camera.viewportWidth = $game_width * 1.0 / 35
    # @camera.viewportHeight = $game_height * 1.0 / 35
    # @camera.viewportWidth = $game_width
    # @camera.viewportHeight = $game_height
    @look_at = vec2(@camera.viewportWidth * 0.5, @camera.viewportHeight * 0.5)
    # @camera.position.set(@camera.viewportWidth * 0.5, @camera.viewportHeight * 0.5, 0)
    update_camera

    @hud_camera = OrthographicCamera.new
    @hud_camera.viewportWidth = $game_width
    @hud_camera.viewportHeight = $game_height
    @hud_camera.position.set(@hud_camera.viewportWidth * 0.5, @hud_camera.viewportHeight * 0.5, 0)
    @hud_camera.update

    @font = BitmapFont.new

    # GROUND
    bodyDef = BodyDef.new
    bodyDef.position.set(0,0.5)
    body = @world.createBody(bodyDef)

    poly = PolygonShape.new
    poly.setAsBox(50, 0.5)
    box_def = FixtureDef.new
    box_def.shape = poly
    box_def.friction = 1
    box_def.density = 0
    body.createFixture(box_def)

    poly.setAsBox(1, 2, vec2(-50, 0.5), 0)
    body.createFixture(box_def)

    poly.setAsBox(1, 2, vec2(50, 0.5), 0)
    body.createFixture(box_def)
    
    poly.setAsBox(3, 0.5, vec2(5, 1.5), Math::PI / 4)
    body.createFixture(box_def)
 
    poly.setAsBox(3, 0.5, vec2(3.5, 1), Math::PI / 8)
    body.createFixture(box_def)
 
    poly.setAsBox(3, 0.5, vec2(9, 1.5), -Math::PI / 4)
    body.createFixture(box_def)
 
    poly.setAsBox(3, 0.5, vec2(10.5, 1), -Math::PI / 8)
    body.createFixture(box_def)

    body.reset_mass_data
    
    # CART
    @cart_x = 20
    @cart_y = 2.5
    body_def = BodyDef.new
    body_def.type = BodyDef::BodyType::DynamicBody  
    body_def.position.set(@cart_x, @cart_y)
    @cart = @world.createBody(body_def)
 
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

    @cart.createFixture(box_def)

    @cart.reset_mass_data
 
 
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
    wheel_def.position.set(@cart_x - 2, @cart_y - 0.6)

    @wheel1 = @world.create_body(wheel_def)
    @wheel1.create_fixture(circle_def)
    @wheel1.reset_mass_data

    wheel_def.position.set(@cart_x + 2, @cart_y - 0.6)
    @wheel2 = @world.create_body(wheel_def)
    @wheel2.create_fixture(circle_def)
    @wheel2.reset_mass_data
 
    # rdef = RevoluteJointDef.new
    # rdef.enableMotor = true
    # rdef.initialize__method(@cart, @wheel1, @wheel1.world_center)
    # @motor1 = @world.create_joint(rdef)

    # rdef.initialize__method(@cart, @wheel2, @wheel2.world_center)
    # @motor2 = @world.create_joint(rdef)
    
# jd.Initialize(m_car, m_wheel1, m_wheel1->GetPosition(), axis);
# 			jd.motorSpeed = 0.0f;
# 			jd.maxMotorTorque = 20.0f;
# 			jd.enableMotor = true;
# 			jd.frequencyHz = m_hz;
# 			jd.dampingRatio = m_zeta;
# 			m_spring1 = (b2WheelJoint*)m_world->CreateJoint(&jd);
    
    jd = WheelJointDef.new
    jd.initialize__method(@cart, @wheel1, @wheel1.world_center, vec2(0,1.0))
    jd.motorSpeed = 0
    jd.maxMotorTorque = 20.0
    jd.enableMotor = true
    jd.frequencyHz = 50
    jd.dampingRatio = 5
    @motor1 = @world.create_joint(jd)
    
    # @motor1 = @world.create_joint(wdef)

    jd.initialize__method(@cart, @wheel2, @wheel2.world_center, vec2(0,1.0))
    @motor2 = @world.create_joint(jd)

    @sprite_batch = SpriteBatch.new
    @hud_batch = SpriteBatch.new
    @color2x2 = Texture.new(Gdx.files.internal('images/color2x2.png'))
    @chassis = Texture.new(Gdx.files.internal('images/truck_chassis.png'))
    @tire = Texture.new(Gdx.files.internal('images/truck_tire.png'))

    @shape_renderer = ShapeRenderer.new


  rescue Exception => e
    debug_exception e
    @broke = true
  end

  # One of the API methods
  def hide
    # puts "hide()"
  end

  def update_camera
    @camera.position.set(@look_at.x, @look_at.y, 0)
    @camera.update
  end

  def render(d)
    reload_car if Gdx.input.isKeyPressed(Input::Keys::BACKSLASH)
    Gdx.app.exit if Gdx.input.isKeyPressed(Input::Keys::ESCAPE)
    return if @broke

    Gdx.gl.glClear(GL10::GL_COLOR_BUFFER_BIT);  
    @world.step(@BOX_STEP, @BOX_VELOCITY_ITERATIONS, @BOX_POSITION_ITERATIONS);  


    power = 0
    if Gdx.input.isKeyPressed(Input::Keys::LEFT)
      @manual_camera = false
      power = 100
    elsif Gdx.input.isKeyPressed(Input::Keys::RIGHT)
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

    # @cart.apply_torque(0.3*power)
    
    # Drawing 
    # @shape_renderer.setProjectionMatrix(@camera.combined)
    # @shape_renderer.begin(ShapeRenderer::ShapeType::Line)
    # @shape_renderer.setColor(1, 0, 0, 1);
    # @shape_renderer.line(0,0, 20,20);
    # @shape_renderer.end

    if Gdx.input.isKeyPressed(Input::Keys::W)
      @zoom_factor += 1
      @zoom_factor = 1 if @zoom_factor < 1
    end
    if Gdx.input.isKeyPressed(Input::Keys::S)
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
      @look_at.x = @cart.position.x
      @look_at.y = @cart.position.y + 7
    end
    update_camera

    # Images
    #

    @sprite_batch.setProjectionMatrix(@camera.combined)
    @sprite_batch.begin


      # batch.draw(
      #   render_comp.image,                          # Texture
      #   loc_comp.x, loc_comp.y,                     # x, y
      #   render_comp.width/2, render_comp.height/2,  # originX, originY
      #   render_comp.width, render_comp.height,      # width, height
      #   1.0, 1.0,                                   # scaleX, scaleY
      #   render_comp.rotation,                       # rotation
      #   0, 0,                                       # srcX, srcY
      #   render_comp.width, render_comp.height,      # srcWidth, srcHeight
      #   false, false                                # flipX, flipY
      # )

    if false
      @sprite_batch.draw(
        @color2x2, 
        @cart.position.x - 1, @cart.position.y,
        1,0, #@color2x2.width/2.0, @color2x2.height/2.0,
        @color2x2.width, @color2x2.height,
        1.0, 1.0,
        rad2deg(@cart.getAngle),
        0,0,
        @color2x2.width, @color2x2.height,
        false,false
      )
    end


    if true
      scale = 0.022
      tsw = @tire.width * scale
      tsh = @tire.height * scale
      @sprite_batch.draw(
        @tire, 
        @wheel1.position.x - (tsw/2), @wheel1.position.y - (tsh/2), 
        (tsw/2), (tsh/2),
        @tire.width*scale, @tire.height*scale,
        1.0, 1.0,
        rad2deg(@wheel1.getAngle),
        0,0,
        @tire.width, @tire.height,
        false,false
      )
      @sprite_batch.draw(
        @tire, 
        @wheel2.position.x - (tsw/2), @wheel2.position.y - (tsh/2), 
        (tsw/2), (tsh/2),
        @tire.width*scale, @tire.height*scale,
        1.0, 1.0,
        rad2deg(@wheel2.getAngle),
        0,0,
        @tire.width, @tire.height,
        false,false
      )
    end

    if true
      scale = 0.022
      # csw = @chassis.width * scale
      # csh = @chassis.height * scale
      @sprite_batch.draw(
        @chassis, 
        @cart.position.x-3.3, @cart.position.y, 
        3.3, 0,
        @chassis.width*scale, @chassis.height*scale,
        1.0, 1.0,
        rad2deg(@cart.getAngle),
        0,0,
        @chassis.width, @chassis.height,
        false,false
      )
    end

    if false
      scale = 0.022
      # csw = @chassis.width * scale
      # csh = @chassis.height * scale
      @sprite_batch.draw(
        @chassis, 
        @cart.position.x, @cart.position.y,
        @chassis.width*scale, @chassis.height*scale
      )
      #   scale,scale,
      #   rad2deg(@cart.getAngle),
      #   0,0,
      #   @chassis.width, @chassis.height,
      #   false,false
      # )
    end


    @sprite_batch.end

    @debug_renderer.render(@world, @camera.combined) if @do_debug_render

    @hud_batch.setProjectionMatrix(@hud_camera.combined)
    @hud_batch.begin
    @font.draw(@hud_batch, "P -> Play, Q -> Quit", 8, 20);
    @hud_batch.end

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

end
