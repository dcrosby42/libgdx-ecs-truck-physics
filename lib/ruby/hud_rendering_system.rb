
class HudRenderingSystem
  def tick(delta, entity_manager)
    entity_manager.each_entity_with_component_of_type(HudViewport) do |e,hv|
      hv.sprite_batch.setProjectionMatrix(hv.camera.combined)
      hv.sprite_batch.begin
      lines = [
        "Drive: Left/Right.  Zoom: W/S.  Pan: A/D.  Reload: \\",
        "F1: draw physics, F2: renderables, F3: debugz",
        # "FPS: #{hv.current_fps} Time per loop: #{hv.time_per_loop}"
      ]

      (lines + hv.debug_lines).each.with_index do |line,i|
        hv.font.draw(hv.sprite_batch, line, 8, (i+1)*20);
      end

      hv.sprite_batch.end
    end
  end
end

