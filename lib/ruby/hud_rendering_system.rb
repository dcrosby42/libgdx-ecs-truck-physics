
class HudRenderingSystem
  def tick(delta, hud_viewport)
    hv = hud_viewport
    hv.sprite_batch.setProjectionMatrix(hv.camera.combined)
    hv.sprite_batch.begin
    hv.font.draw(hv.sprite_batch, "Drive: Left/Right.  Zoom: W/S.  Pan: A/D.  Reload: \\", 8, 20);
    hv.sprite_batch.end

    # Drawing shapes using GL utils:
    # @shape_renderer.setProjectionMatrix(@camera.combined)
    # @shape_renderer.begin(ShapeRenderer::ShapeType::Line)
    # @shape_renderer.setColor(1, 0, 0, 1);
    # @shape_renderer.line(0,0, 20,20);
    # @shape_renderer.end
  end
end
