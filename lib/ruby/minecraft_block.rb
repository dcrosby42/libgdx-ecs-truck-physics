class MinecraftBlock
  attr_accessor :body, :renderable

  def self.create(opts={})
    world = opts[:world] || raise("Supply :world")
    body_x = opts[:x] || 10
    body_y = opts[:y] || 6

    # tex fname
    # tex scale: scale multiplier to size the image to the environment. 
    # offset_x and offset_uy -- center of box, 0,0 means math center of the box (this is default)
    # source x/y: where in the text to start taking from (lower left), measured in pixels in the image
    # source w/h: how much of the source tex to use, reaching up and right from the lower left specified by source x/y, measured in pixels in the image
    #
    # box w/h
    # friction
    # density
    # restitution
    # groupIndex 

    body_def = BodyDef.new
    body_def.type = BodyDef::BodyType::DynamicBody  
    body_def.position.set(body_x, body_y)
    body = world.createBody(body_def)

    box_def = FixtureDef.new
    box_def.shape = PolygonShape.new
    box_def.shape.set_as_box(1.0, 1.0)
    box_def.friction = 0.3
    box_def.density = 0.5 
    box_def.restitution = 0.1
    # box_def.filter.groupIndex = -1

    body.createFixture(box_def)

    body.reset_mass_data


    tex = load_texture('minecraft_sheet.png')
    r = 7
    c = 7
    body_rend = Renderable.create(texture: tex, 
                                  texture_scale: 0.008, 
                                  offset_x: 0.0, offset_y: 0.0,
                                  source_x: c*16, source_y: r*16,
                                  source_width: 16, source_height: 16,
                                 )

    #
    # body_pts = vec2_array([
    #   [3,1],
    #   [-3.2,1],
    #   [-3.2,0.7],
    #   [-1.2,0.7],
    #   [-1,0.0],
    #   [0.8,0.0],
    #   [1.2,0.7],
    #   [3,0.7]
    # ])
    # cab_pts = vec2_array([
    #   [1.5, 1],
    #   [0.5, 1.5],
    #   [-2.8, 1.5],
    #   [-3.2, 1],
    # ])
    # rear_fender_pts = vec2_array([
    #   [-3.2,0.7],
    #   [-3.2,0.3],
    #   [-2.2,0.7],
    # ])

    # [body_pts, cab_pts, rear_fender_pts].each do |pts|
    #   box_def.shape.set pts 
    #   truck_body.createFixture(box_def)
    # end

    # truck_body.reset_mass_data
 
 
    # circle_def = FixtureDef.new
    # circle_def.shape = CircleShape.new
    # circle_def.shape.radius = 0.9
    # circle_def.friction = 5
    # circle_def.density = 1#0.1
    # circle_def.restitution = 0.2
    # circle_def.filter.groupIndex = -1
 
    # wheel_def = BodyDef.new
    # wheel_def.type = BodyDef::BodyType::DynamicBody
    # wheel_def.allowSleep = false 
    # wheel_def.position.set(truck_body_x - 2, truck_body_y - 0.6)

    # wheel1 = world.create_body(wheel_def)
    # wheel1.create_fixture(circle_def)
    # wheel1.reset_mass_data

    # wheel_def.position.set(truck_body_x + 2, truck_body_y - 0.6)
    # wheel2 = world.create_body(wheel_def)
    # wheel2.create_fixture(circle_def)
    # wheel2.reset_mass_data

    # #
    # # WHEEL JOINTS
    # #
    # jd = WheelJointDef.new
    # jd.initialize__method(truck_body, wheel1, wheel1.world_center, vec2(0,1.0))
    # jd.motorSpeed = 0
    # jd.maxMotorTorque = 50.0
    # jd.enableMotor = true
    # jd.frequencyHz = 4
    # jd.dampingRatio = 0.5
    # motor1 = world.create_joint(jd)

    # jd.initialize__method(truck_body, wheel2, wheel2.world_center, vec2(0,1.0))
    # motor2 = world.create_joint(jd)

    # # RENDERABLES
    # # chassis = Texture.new(Gdx.files.internal(RELATIVE_ROOT + 'images/truck_chassis.png'))
    # chassis = load_texture('truck_chassis.png')
    # truck_body_rend = Renderable.create(texture: chassis, texture_scale: 0.022, offset_x: -0.15, offset_y: 0.75)

    # # tire = Texture.new(Gdx.files.internal(RELATIVE_ROOT + 'images/truck_tire.png'))
    # tire = load_texture('truck_tire.png')
    # wheel1_rend = Renderable.create(texture: tire, texture_scale: 0.022)
    # wheel2_rend = Renderable.create(texture: tire, texture_scale: 0.022)

    # tc = TruckComponent.new
    # tc.truck_body = truck_body
    # tc.wheel1 = wheel1
    # tc.wheel2 = wheel2
    # tc.motor1 = motor1
    # tc.motor2 = motor2
    # tc.truck_body_rend = truck_body_rend
    # tc.wheel1_rend = wheel1_rend
    # tc.wheel2_rend = wheel2_rend
    # tc

    mb = MinecraftBlock.new
    mb.body = body
    mb.renderable = body_rend
    mb


  end
end
