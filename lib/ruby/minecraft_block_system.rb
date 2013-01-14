class MinecraftBlockSystem

  def tick(delta, entity_manager)
    entities = entity_manager.get_all_entities_with_components_of_type([MinecraftBlock, ControlComponent])
    entities.each do |e|
      minecraft_block = entity_manager.get_component_of_type(e, MinecraftBlock)
      control = entity_manager.get_component_of_type(e, ControlComponent)

      if control.right
        #minecraft_block.body.apply_force(300,100, 0.5,0.5)
        minecraft_block.body.set_linear_velocity 5,8
      elsif control.left
        minecraft_block.body.set_linear_velocity -5,8
        #minecraft_block.body.apply_force(-300,100, 0.5,0.5)
      elsif control.down
        minecraft_block.body.set_linear_velocity 0,-8
      end
    end
  end
end
