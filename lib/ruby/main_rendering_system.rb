
class MainRenderingSystem

    # @main_rendering_system.tick(delta, @main_viewport, [
    #   @truck_component.wheel1_rend,
    #   @truck_component.wheel2_rend,
    #   @truck_component.truck_body_rend,
    # ])
  
  # def tick(delta, main_viewport, renderables)
  def tick(delta, entity_manager)
    level = entity_manager.get_all_entities_with_tag('level').first || raise("Need entity tagged 'level'")
    ground_component = entity_manager.get_component_of_type(level, GroundComponent)
    main_viewport    = entity_manager.get_component_of_type(level, MainViewport)

    return unless main_viewport.do_renderable_renders

    batch = main_viewport.sprite_batch
    batch.setProjectionMatrix(main_viewport.camera.combined)
    batch.begin

    # Players' vehicles
    entities = entity_manager.get_all_entities_with_component_of_type(TruckComponent)
    entities.each do |player|
      truck_component = entity_manager.get_component_of_type(player, TruckComponent)
      draw_renderable batch, truck_component.wheel1_rend
      draw_renderable batch, truck_component.wheel2_rend
      draw_renderable batch, truck_component.truck_body_rend
    end
    
    # Ground debris
    ground_component.rend_body_pairs.each do |(renderable,body)| 
      draw_renderable batch, renderable
    end
      
    # Ground contour
      # Drawing shapes using GL utils:
      # @shape_renderer.setProjectionMatrix(@camera.combined)
      # @shape_renderer.begin(ShapeRenderer::ShapeType::Line)
      # @shape_renderer.setColor(1, 0, 0, 1);
      # @shape_renderer.line(0,0, 20,20);
      # @shape_renderer.end
    
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
