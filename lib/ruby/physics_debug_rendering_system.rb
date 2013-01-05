
class PhysicsDebugRenderingSystem
  def tick(delta, physics_component, main_viewport)
    if physics_component.do_debug_render
      physics_component.debug_renderer.render(physics_component.world, main_viewport.camera.combined) 
    end
  end
end
