
class MainRenderingSystem

    # @main_rendering_system.tick(delta, @main_viewport, [
    #   @truck_component.wheel1_rend,
    #   @truck_component.wheel2_rend,
    #   @truck_component.truck_body_rend,
    # ])
  
  # def tick(delta, main_viewport, renderables)
  TOP_SKY_COLOR = Color.new(0.7, 0.7, 1.0, 1.0)
  BOTTOM_SKY_COLOR = Color.new(0.0, 0.0, 0.4, 1.0)

  def tick(delta, entity_manager)
    level = entity_manager.get_all_entities_with_tag('level').first || raise("Need entity tagged 'level'")
    ground_component = entity_manager.get_component_of_type(level, GroundComponent)
    main_viewport    = entity_manager.get_component_of_type(level, MainViewport)
    hud_viewport    = entity_manager.get_component_of_type(level, HudViewport)

    return unless main_viewport.do_renderable_renders

    batch = main_viewport.sprite_batch
    sr = main_viewport.shape_renderer
    # Sky
    sr.begin(ShapeRenderer::ShapeType::FilledRectangle)
      sr.setProjectionMatrix(hud_viewport.camera.combined)
      # sr.setColor(0.3, 0.3, 0.4, 1);
      sr.filledRect(0,0, $game_width, $game_height, 
                   BOTTOM_SKY_COLOR, BOTTOM_SKY_COLOR, TOP_SKY_COLOR, TOP_SKY_COLOR)
    sr.end

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


    entities = entity_manager.get_all_entities_with_component_of_type(MinecraftBlock)
    entities.each do |e|
      mcb = entity_manager.get_component_of_type(e, MinecraftBlock)
      draw_renderable batch, mcb.renderable
    end


    
    # Ground debris
    ground_component.rend_body_pairs.each do |(renderable,body)| 
      draw_renderable batch, renderable
    end
    batch.end
      
    # Ground contour

    sr.setProjectionMatrix(main_viewport.camera.combined)
    # sr.begin(ShapeRenderer::ShapeType::Line)
    sr.begin(ShapeRenderer::ShapeType::FilledTriangle)
    sr.setColor(0.1, 0.5, 0.1, 1);
    ground_component.ground_contour_points.each_cons(2) do |(x1,y1), (x2,y2)|
      if y1 > y2
        sr.filledTriangle(x1,y2,  x2,y2,  x1,y1)
      else
        sr.filledTriangle(x1,y1,  x2,y1,  x2,y2)
      end
    end
    sr.end

    sr.begin(ShapeRenderer::ShapeType::FilledRectangle)
    # sr.setColor(1, 0, 0, 1);
    bottom = -100
    ground_component.ground_contour_points.each_cons(2) do |(x1,y1), (x2,y2)|
      height = y1 - bottom
      if y1 > y2 # downhill going right
        height = y2 - bottom
      end
      sr.filledRect(x1,bottom, x2-x1, height)
    end
    sr.end
    
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
