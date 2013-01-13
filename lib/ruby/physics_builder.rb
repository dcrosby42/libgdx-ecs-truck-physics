module PhysicsBuilder

  def create_dynamic_body(world,opts={})
    body_def = BodyDef.new
    body_def.type = BodyDef::BodyType::DynamicBody  
    body_def.position.set(
      opts[:x] || 0, 
      opts[:y] || 0
    )
    world.createBody(body_def)
  end

  def create_polygon_fixture(body,opts={})
    box_def = FixtureDef.new
    box_def.shape = PolygonShape.new
    box_def.shape.set_as_box(
      opts[:width] || 10,
      opts[:height] || 10
    )
    box_def.friction = opts[:friction] || 0.3
    box_def.density = opts[:density] || 0.5 
    box_def.restitution = opts[:resitution] || 0.2

    # TODO box_def.filter.groupIndex = -1
    body.createFixture(box_def)
    body.reset_mass_data
    box_def
  end

end
