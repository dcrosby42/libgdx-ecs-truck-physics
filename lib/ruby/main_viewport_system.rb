
class MainViewportSystem
  def tick(delta, main_viewport, input_processor)
    mv = main_viewport
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
    
    # Keyboard control of camera:
    if Gdx.input.isKeyPressed(Input::Keys::A)
      mv.look_at.x -= 0.2
      mv.manual_camera = true
    end
    if Gdx.input.isKeyPressed(Input::Keys::D)
      mv.look_at.x += 0.2 
      mv.manual_camera = true
    end

    # Camera follows vehicle
    if !mv.manual_camera and !mv.follow_body.nil?
      mv.look_at.x = mv.follow_body.position.x
      mv.look_at.y = mv.follow_body.position.y + 7
    end

    mv.camera.position.set(mv.look_at.x, mv.look_at.y, 0)
    mv.camera.update
  end
end
