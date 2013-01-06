
class MainViewportSystem
  def tick(delta, entity_manager)
    level = entity_manager.get_all_entities_with_tag("level").first || raise("Can't find the 'level' entity!")
    input_processor = entity_manager.get_component_of_type(level, MyInputProcessor)

    entities = entity_manager.get_all_entities_with_component_of_type(MainViewport)
    entities.each do |e|
      mv = entity_manager.get_component_of_type(e, MainViewport)

      if input_processor.key_down?(Input::Keys::W)
        mv.zoom_factor += 1
        mv.zoom_factor = 1 if mv.zoom_factor < 1
      end
      if input_processor.key_down?(Input::Keys::S)
        mv.zoom_factor -= 1
      end
      if input_processor.key_down?(Input::Keys::LEFT) or input_processor.key_down?(Input::Keys::RIGHT)
        mv.manual_camera = false
      end

      mv.camera.viewportWidth = mv.game_width * 1.0 / mv.zoom_factor
      mv.camera.viewportHeight = mv.game_height * 1.0 / mv.zoom_factor

      if input_processor.key_pressed?(Input::Keys::F1)
        mv.do_physics_debug_render = !mv.do_physics_debug_render
      end
      if input_processor.key_pressed?(Input::Keys::F2)
        mv.do_renderable_renders = !mv.do_renderable_renders
      end
      
      # Keyboard control of camera:
      pan_amt = 0.2
      if input_processor.key_down?(Input::Keys::A)
        mv.look_at.x -= pan_amt
        mv.manual_camera = true
      end
      if input_processor.key_down?(Input::Keys::D)
        mv.look_at.x += pan_amt
        mv.manual_camera = true
      end

      # Camera follows vehicle
      if !mv.manual_camera and !mv.follow_body.nil?
        mv.look_at.x = mv.follow_body.position.x
        mv.look_at.y = mv.follow_body.position.y + 4
      end

      mv.camera.position.set(mv.look_at.x, mv.look_at.y, 0)
      mv.camera.update
    end
  end
end
