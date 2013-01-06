
class TruckComponent
  extend MathUtils
  attr_accessor :truck_body, :wheel1, :wheel2, :motor1, :motor2, :truck_body_rend, :wheel1_rend, :wheel2_rend

  def self.create(opts={})
    world = opts[:world] || raise("Supply :world")
    truck_body_x = opts[:x] || 10
    truck_body_y = opts[:y] || 6
    body_def = BodyDef.new
    body_def.type = BodyDef::BodyType::DynamicBody  
    body_def.position.set(truck_body_x, truck_body_y)
    truck_body = world.createBody(body_def)
 
    box_def = FixtureDef.new
    box_def.shape = PolygonShape.new
    box_def.friction = 0.5
    box_def.density = 1
    box_def.restitution = 0.2
    box_def.filter.groupIndex = -1

    body_pts = vec2_array([
      [3,1],
      [-3.2,1],
      [-3.2,0.7],
      [-1.2,0.7],
      [-1,0.0],
      [0.8,0.0],
      [1.2,0.7],
      [3,0.7]
    ])
    cab_pts = vec2_array([
      [1.5, 1],
      [0.5, 1.5],
      [-2.8, 1.5],
      [-3.2, 1],
    ])
    rear_fender_pts = vec2_array([
      [-3.2,0.7],
      [-3.2,0.3],
      [-2.2,0.7],
    ])

    [body_pts, cab_pts, rear_fender_pts].each do |pts|
      box_def.shape.set pts 
      truck_body.createFixture(box_def)
    end

    truck_body.reset_mass_data
 
 
    circle_def = FixtureDef.new
    circle_def.shape = CircleShape.new
    circle_def.shape.radius = 0.9
    circle_def.friction = 5
    circle_def.density = 1#0.1
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
    jd.frequencyHz = 5
    jd.dampingRatio = 0.7
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
