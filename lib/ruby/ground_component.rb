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
