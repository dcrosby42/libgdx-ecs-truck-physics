class PhysicsSystem
  def tick(delta, entity_manager)
    entities = entity_manager.get_all_entities_with_component_of_type(PhysicsComponent)
    entities.each do |e|
      physics_component = entity_manager.get_component_of_type(e, PhysicsComponent)
      physics_component.world.step(
        physics_component.step, 
        physics_component.velocity_iterations, 
        physics_component.position_iterations
      ) 
    end
  end
end
