
class HudViewportSystem
  def tick(delta, entity_manager)
    level = entity_manager.get_entity_with_tag("level")
    hud_viewport = entity_manager.get_component_of_type(level, HudViewport)
    hud_viewport.camera.update
  end
end
