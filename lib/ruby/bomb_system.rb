class BombSystem
  def tick(delta, entity_manager)
    entity_manager.each_entity_with_components_of_type([BombComponent, ControlComponent]) do |e,bomb,control|

      if control.ignite
        puts "ignite"
        bomb.state = :ignite
      end

      case bomb.state
      when :ignite
        bomb.state = :ticking
        bomb.timer = 1
        bomb.fuse_sound.play(1,0.7,0)
      when :ticking
        if bomb.timer > 0
          bomb.timer -= delta
          bomb.timer = 0 if bomb.timer < 0
        else
          bomb.state = :splode
        end
      when :splode
        bomb.explode_sound.play(1,0.7,0)
        puts "*!BOMB SPLODE!*"
        bomb.state = :sploded

        minecraft_block = entity_manager.get_component_of_type(e, MinecraftBlock)


        entity_manager.each_entity_with_component_of_type(ExplodableComponent) do |ee, exp|
          exp.add Explosion.new(
            center: minecraft_block.body.position.cpy,
            power: bomb.power,
            radius: bomb.radius
          )
        end

        # Kill the bomb object from entity and physics space:
        # (Should I be bummed about coupling this code to MinecraftBlock and 
        # the idea that it has a phys body which needs to be removed?
        # The bomb system was coming together fairly generically... maybe it can be
        # split into a starter/timer and reactor via a configured target...)
        level = entity_manager.get_entity_with_tag("level")
        physics_component = entity_manager.get_component_of_type(level, PhysicsComponent)

        physics_component.world.destroy_body minecraft_block.body
        entity_manager.kill_entity e
      end

    end
  end
end
