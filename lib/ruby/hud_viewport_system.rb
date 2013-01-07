
class HudViewportSystem
  def tick(delta, entity_manager)
    level = entity_manager.get_all_entities_with_tag("level").first || raise("Can't find the 'level' entity!")
    hud_viewport = entity_manager.get_component_of_type(level, HudViewport)
    hud_viewport.camera.update
  end
end
