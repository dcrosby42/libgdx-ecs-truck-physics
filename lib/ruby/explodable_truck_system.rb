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
          ray = pos.cpy.sub(explosion.center)
          force = Vector2.new(0,1000).add(ray.cpy.mul(10 * explosion.power))
          spin = 70
          # puts "#{entity_manager.get_tag(e)} truck SPLODED! ray=#{ray} force=#{force} spin=#{spin}"


          truck_component.truck_body.apply_force_to_center force
          truck_component.truck_body.apply_angular_impulse spin
        else
          puts "#{entity_manager.get_tag(e)} truck missed by explosion!"
        end

        exp_component.explosion = nil
      end
    end


  end
end
