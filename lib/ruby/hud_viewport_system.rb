
class HudViewportSystem
  def tick(delta, entity_manager)
    entities = entity_manager.get_all_entities_with_component_of_type(HudViewport)
    entities.each do |e|
      hv = entity_manager.get_component_of_type(e, HudViewport)

      hv.camera.update
    end
  end
end
