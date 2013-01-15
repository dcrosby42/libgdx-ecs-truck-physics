class PhysicsSystem
  def tick(delta, entity_manager)
    entity_manager.each_entity_with_component_of_type(PhysicsComponent) do |e, physics_component|
      physics_component.world.step(
        physics_component.step, 
        physics_component.velocity_iterations, 
        physics_component.position_iterations
      ) 
    end
  end
end
