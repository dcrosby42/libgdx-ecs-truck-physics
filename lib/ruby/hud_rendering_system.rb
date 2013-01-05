
class HudRenderingSystem
  def tick(delta, entity_manager)
    entities = entity_manager.get_all_entities_with_component_of_type(HudViewport)
    entities.each do |e|
      hv = entity_manager.get_component_of_type(e, HudViewport)
      hv.sprite_batch.setProjectionMatrix(hv.camera.combined)
      hv.sprite_batch.begin
      hv.font.draw(hv.sprite_batch, "Drive: Left/Right.  Zoom: W/S.  Pan: A/D.  Reload: \\", 8, 20);
      hv.sprite_batch.end
    end
  end
end
