class ExplodableTruckSystem
  def tick(delta,entity_manager)
    entity_manager.each_entity_with_components_of_type([TruckComponent, ExplodableComponent]) do |e, truck_component, exp_component|
      exp_component.explosions.each do |explosion|
        pos = truck_component.truck_body.position
        if explosion.covers?(pos)
          ray = pos.cpy.sub(explosion.center)
          force = Vector2.new(0,1000).add(ray.cpy.mul(10 * explosion.power))
          spin = 70
          if ray.x > 0
            spin *= -1
          end
          puts "#{entity_manager.get_tag(e)} truck SPLODED! ray=#{ray} force=#{force} spin=#{spin}"


          truck_component.truck_body.apply_force_to_center force
          truck_component.truck_body.apply_angular_impulse spin
        else
          puts "#{entity_manager.get_tag(e)} truck missed by explosion!"
        end

        exp_component.clear
      end
    end


  end
end
