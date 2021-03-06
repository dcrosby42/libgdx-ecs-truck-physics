class ExplodableStoneSystem
  def tick(delta,entity_manager)
    entity_manager.each_entity_with_components_of_type([GroundComponent, ExplodableComponent]) do |e,_,exp_component|
      exp_component.explosions.each do |explosion|
        puts "#{entity_manager.get_tag(e)} ground exploded!"
        ground_component = entity_manager.get_component_of_type(e, GroundComponent)
        ground_component.stones.each do |body|
          pos = body.position.cpy
          if explosion.covers?(pos)
            ray = pos.cpy.sub(explosion.center)
            body.apply_force_to_center Vector2.new(0,10).add(ray.mul(30))
            body.apply_angular_impulse 10
          end
        end
        exp_component.clear

      end
    end


  end
end
