
class MainRenderingSystem
  def tick(delta, main_viewport, renderables)
    batch = main_viewport.sprite_batch
    batch.setProjectionMatrix(main_viewport.camera.combined)
    batch.begin
    renderables.each do |r|
      draw_renderable batch, r
    end
    batch.end
  end

  private
  def draw_renderable(sprite_batch, r)
    sprite_batch.draw(
      r.texture,
      r.x, r.y,
      r.origin_x, r.origin_y,
      r.width, r.height,
      r.scale_x, r.scale_y,
      r.angle_degrees,
      r.source_x, r.source_y,
      r.source_width, r.source_height,
      r.flip_x, r.flip_y
    )
    r
  end
end
