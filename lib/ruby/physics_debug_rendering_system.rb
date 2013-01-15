
class PhysicsDebugRenderingSystem
  def tick(delta, entity_manager)
    physics_components = entity_manager.get_all_components_of_type(PhysicsComponent)
    entity_manager.each_entity_with_component_of_type(MainViewport) do |e,main_viewport|
      if main_viewport.do_physics_debug_render
        physics_components.each do |physics_component|
          physics_component.debug_renderer.render(physics_component.world, main_viewport.camera.combined) 
        end
      end
    end
  end
end
