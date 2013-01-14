class BombSystem
  def tick(delta, entity_manager)
    entities = entity_manager.get_all_entities_with_components_of_type([BombComponent, ControlComponent])
    entities.each do |e|
      bomb = entity_manager.get_component_of_type(e, BombComponent)
      control = entity_manager.get_component_of_type(e, ControlComponent)

      if control.ignite
        puts "ignite"
        bomb.state = :ignite
      end

      case bomb.state
      when :ignite
        bomb.state = :ticking
        bomb.timer = 1
      when :ticking
        if bomb.timer > 0
          bomb.timer -= delta
          bomb.timer = 0 if bomb.timer < 0
        else
          bomb.state = :splode
        end
      when :splode
        puts "*!BOMB SPLODE!*"
        puts Time.now.to_f
        bomb.state = :sploded


        # Should I be bummed about coupling this code to MinecraftBlock and 
        # the idea that it has a phys body which needs to be removed?
        # The bomb system was coming together fairly generically... maybe it can be
        # split into a starter/timer and reactor via a configured target...
        minecraft_block = entity_manager.get_component_of_type(e, MinecraftBlock)
        level = entity_manager.get_all_entities_with_tag("level").first || raise("Can't find the 'level' entity!")
        physics_component = entity_manager.get_component_of_type(level, PhysicsComponent)

        physics_component.world.destroy_body minecraft_block.body
        entity_manager.kill_entity e
      end

    end
  end
end
