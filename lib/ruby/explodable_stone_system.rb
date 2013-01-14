class ExplodableStoneSystem
  def tick(delta,entity_manager)
    entities = entity_manager.get_all_entities_with_components_of_type([GroundComponent, ExplodableComponent])
    entities.each do |e|
      exp = entity_manager.get_component_of_type(e, ExplodableComponent)
      if exp.explosion
        puts "#{entity_manager.get_tag(e)} ground exploded!"
        
        # ground_component = entity_manager.get_component_of_type(e, GroundComponent)
        # ground_component.stones.each do |body|
        #   body.apply_force_to_center Vector2.new(0,60)
        #   body.apply_angular_impulse 10
        # end

        exp.explosion = nil
      end
    end


  end
end
