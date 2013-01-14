module PhysicsBuilder
  include MathUtils

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
    if opts[:width] and opts[:height]
      box_def.shape.set_as_box(
        (opts[:width] || 1) / 2.0,
        (opts[:height] || 1) / 2.0
      )
    elsif opts[:points]
      box_def.shape.set opts[:points]
    else
      raise "Need either :width and :height for a box, or :points for a polygon"
    end
    box_def.friction = opts[:friction] || 0.3
    box_def.density = opts[:density] || 0.5 
    box_def.restitution = opts[:resitution] || 0.2

    # TODO box_def.filter.groupIndex = -1
    body.createFixture(box_def)
    body.reset_mass_data
    box_def
  end

end
