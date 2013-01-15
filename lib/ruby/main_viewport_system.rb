
class MainViewportSystem
  def tick(delta, entity_manager)
    level = entity_manager.get_entity_with_tag("level")
    mv = entity_manager.get_component_of_type(level, MainViewport) || raise("No MainViewPort")
    control = entity_manager.get_component_of_type(level, ControlComponent) || raise("No ControlComponent")

    if control.zoom_out
      mv.zoom_factor -= 1
    end
    if control.zoom_in
      mv.zoom_factor += 1
    end
    mv.zoom_factor = 2 if mv.zoom_factor < 2
    mv.zoom_factor = 100 if mv.zoom_factor > 100


    mv.camera.viewportWidth = mv.game_width * 1.0 / mv.zoom_factor
    mv.camera.viewportHeight = mv.game_height * 1.0 / mv.zoom_factor

    if control.toggle_draw_physics
      mv.do_physics_debug_render = !mv.do_physics_debug_render
    end
    if control.toggle_draw_renderables
      mv.do_renderable_renders = !mv.do_renderable_renders
    end
    
    if control.toggle_follow_player
      mv.follow_player = case mv.follow_player
                         when nil
                           'player1'
                         when 'player1'
                           'player2'
                         else
                           nil
                         end
    end

    # Camera follows vehicle
    if mv.follow_player 
      entity = entity_manager.get_entity_with_tag(mv.follow_player)
      truck_component = entity_manager.get_component_of_type(entity, TruckComponent) || raise("Entity '#{mv.follow_player}' doesn't have a TruckComponent")
      body = truck_component.truck_body

      mv.look_at.x = body.position.x
      mv.look_at.y = body.position.y + 4
    else
      pan_amt = 0.2
      if control.pan_left
        mv.look_at.x -= pan_amt
      end
      if control.pan_right
        mv.look_at.x += pan_amt
      end
    end

    mv.camera.position.set(mv.look_at.x, mv.look_at.y, 0)
    mv.camera.update
  end
end
