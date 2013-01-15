
class BodyRenderableSystem
  include MathUtils
  def tick(delta, entity_manager)
    OLD_tick delta, entity_manager

    entities = entity_manager.get_all_entities_with_component_of_type(BodyRenderable)
    entities.each do |e|
      brends = entity_manager.get_components_of_type(e,BodyRenderable)
      brends.each do |br|
        body = br.body
        br.x = body.position.x - br.center_x
        br.y = body.position.y - br.center_y
        br.angle_degrees = rad2deg(body.angle)
      end
    end

  end

  def OLD_tick(delta, entity_manager)
    rend_body_pairs = []

    # FIXME this is all stupid
    
    # Ground / debris:
    level = entity_manager.get_entity_with_tag('level')
    ground_component = entity_manager.get_component_of_type(level, GroundComponent)
    rend_body_pairs += ground_component.rend_body_pairs

    # Trucks:
    entity_manager.each_entity_with_component_of_type(TruckComponent) do |e,truck_component|
      rend_body_pairs += [
        [truck_component.wheel1_rend, truck_component.wheel1],
        [truck_component.wheel2_rend, truck_component.wheel2],
        [truck_component.truck_body_rend, truck_component.truck_body],
      ]
    end

    
    rend_body_pairs.each do |(r, body)|
      r.x = body.position.x - r.center_x
      r.y = body.position.y - r.center_y
      r.angle_degrees = rad2deg(body.angle)
    end

  end
end
