class ExplodableTruckSystem
  def tick(delta,entity_manager)
    entities = entity_manager.get_all_entities_with_components_of_type([TruckComponent, ExplodableComponent])
    entities.each do |e|
      exp_component = entity_manager.get_component_of_type(e, ExplodableComponent)
      explosion = exp_component.explosion
      if explosion 
        truck_component = entity_manager.get_component_of_type(e, TruckComponent)
        pos = truck_component.truck_body.position
        if explosion.covers?(pos)
          puts "#{entity_manager.get_tag(e)} truck SPLODED!"
          ray = pos.cpy.sub(explosion.center)

          truck_component.truck_body.apply_force_to_center Vector2.new(0,1000).add(ray.mul(10 * explosion.power))
          truck_component.truck_body.apply_angular_impulse 70
        else
          puts "#{entity_manager.get_tag(e)} truck missed by explosion!"
        end

        exp_component.explosion = nil
      end
    end


  end
end
