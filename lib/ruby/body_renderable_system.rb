
class BodyRenderableSystem
  include MathUtils
  def tick(delta, entity_manager)
    entities = entity_manager.get_all_entities_with_component_of_type(TruckComponent)
    entities.each do |e|
      truck_component = entity_manager.get_component_of_type(e,TruckComponent)

      rend_body_pairs = [
        [truck_component.wheel1_rend, truck_component.wheel1],
        [truck_component.wheel2_rend, truck_component.wheel2],
        [truck_component.truck_body_rend, truck_component.truck_body],
      ]
      rend_body_pairs.each do |(r, body)|
        r.x = body.position.x - r.center_x
        r.y = body.position.y - r.center_y
        r.angle_degrees = rad2deg(body.angle)
      end
    end
  end
end
