class MinecraftBlockSystem

  def tick(delta, entity_manager)
    entity_manager.each_entity_with_components_of_type([MinecraftBlock, ControlComponent]) do |e, minecraft_block, control|
      if control.right
        minecraft_block.body.set_linear_velocity 5,8
      elsif control.left
        minecraft_block.body.set_linear_velocity -5,8
      elsif control.down
        minecraft_block.body.set_linear_velocity 0,-8
      end
    end
  end
end
