class PauseRenderingSystem
  def tick(delta,entity_manager)
    entity_manager.each_entity_with_component_of_type(HudViewport) do |e,hv|
      hv.sprite_batch.setProjectionMatrix(hv.camera.combined)
      hv.sprite_batch.begin
      
      hv.font.draw(hv.sprite_batch, "PAUSED", 400,300)

      hv.sprite_batch.end
    end

  end
end
