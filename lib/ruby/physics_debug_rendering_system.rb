
class PhysicsDebugRenderingSystem
  # def tick(delta, physics_component, main_viewport)
  def tick(delta, entity_manager)
    physics_components = entity_manager.get_all_components_of_type(PhysicsComponent)
    entities = entity_manager.get_all_entities_with_component_of_type(MainViewport)
    entities.each do |e|
      main_viewport = entity_manager.get_component_of_type(e, MainViewport)
      if main_viewport.do_physics_debug_render
        physics_components.each do |physics_component|
          physics_component.debug_renderer.render(physics_component.world, main_viewport.camera.combined) 
        end
      end
    end
  end
end
