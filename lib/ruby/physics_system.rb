  class PhysicsSystem
    def tick(delta, physics_component)
      physics_component.world.step(
        physics_component.step, 
        physics_component.velocity_iterations, 
        physics_component.position_iterations
      ) 
    end
  end
