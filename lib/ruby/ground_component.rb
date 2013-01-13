class GroundComponent
  extend MathUtils
  attr_accessor :ground, :stones, :rend_body_pairs, :ground_contour_points

  def self.create(world)

    # Ground + hill

    # ground_def = BodyDef.new
    # ground_def.position.set(0,0.5)
    # ground = world.createBody(ground_def)

    # poly = PolygonShape.new
    # poly.setAsBox(50, 0.5)
    # box_def = FixtureDef.new
    # box_def.shape = poly
    # box_def.friction = 1
    # box_def.density = 0
    # ground.createFixture(box_def)

    # poly.setAsBox(1, 2, vec2(-50, 0.5), 0)
    # ground.createFixture(box_def)

    # poly.setAsBox(1, 2, vec2(50, 0.5), 0)
    # ground.createFixture(box_def)
    # 
    # poly.setAsBox(3, 0.5, vec2(5, 1.5), Math::PI / 4)
    # ground.createFixture(box_def)
 
    # poly.setAsBox(3, 0.5, vec2(3.5, 1), Math::PI / 8)
    # ground.createFixture(box_def)
 
    # poly.setAsBox(3, 0.5, vec2(9, 1.5), -Math::PI / 4)
    # ground.createFixture(box_def)
 
    # poly.setAsBox(3, 0.5, vec2(10.5, 1), -Math::PI / 8)
    # ground.createFixture(box_def)

    # ground.reset_mass_data

    ground2_def = BodyDef.new
    ground2_def.position.set(0,0)
    ground2 = world.createBody(ground2_def)

    data = (-50..100).step(1.0).to_a.map do |x|
      [x, 3*Math::sin(x/5) ]
    end
    g2pts = vec2_array(
      [[-50,-20]] + data + [[100,-20]]
    )
    # g2pts = vec2_array([
    #   [0,0],
    #   [100,0],
    # ])

    gline = FixtureDef.new
    gline.shape = ChainShape.new
    gline.shape.create_chain g2pts
    gline.friction = 1
    gline.density = 0
    ground2.createFixture(gline)


    box_def = FixtureDef.new
    box_def.shape = PolygonShape.new
    box_def.shape.setAsBox(1, 3, vec2(-50, 2.5), 0)
    box_def.friction = 1
    box_def.density = 0
    ground2.createFixture(box_def)

    box_def.shape.setAsBox(1, 3, vec2(100, 2.5), 0)
    ground2.createFixture(box_def)

    # poly.setAsBox(1, 2, vec2(-50, 0.5), 0)
    # ground.createFixture(box_def)


    ground2.reset_mass_data

    
    gc = new
    # gc.ground = ground
    gc.ground = ground2
    gc.stones = []
    gc.rend_body_pairs = []
    gc.ground_contour_points = data
    
    # STONES: 
    
    # stone1 = Texture.new(Gdx.files.internal(RELATIVE_ROOT + 'images/stone1.png'))
    stone1 = load_texture("stone1.png")

    circle_def = FixtureDef.new
    circle_def.shape = CircleShape.new
    circle_def.friction = 0.5 
    circle_def.density = 0.3
    circle_def.restitution = 0.5
    body_def = BodyDef.new
    body_def.type = BodyDef::BodyType::DynamicBody
    body_def.allowSleep = true
    body_def.linearDamping = 0.1
    body_def.angularDamping = 0.1
    30.times do 
      # circle_def.shape.radius = (rand / 10.0) + 0.2
      scaler = rand + 1
      circle_def.shape.radius = 0.2 * scaler
      body_def.position.set(rand * 35 +  5, 6)
      stone1_rend = BodyRenderable.create(texture: stone1, texture_scale: 0.010 * scaler)

      body = world.create_body(body_def)
      body.create_fixture(circle_def)
      body.reset_mass_data
      gc.stones << body
      gc.rend_body_pairs << [stone1_rend, body]
    end

    # # # # # 
    
    gc
  end

end
