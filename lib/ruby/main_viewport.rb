
class MainViewport
  extend MathUtils
  attr_accessor :camera, :follow_body, :look_at, :zoom_factor, :manual_camera, :sprite_batch, :game_height, :game_width

  def self.create(opts={})
    mv = MainViewport.new
    mv.camera = OrthographicCamera.new
    mv.zoom_factor = 35
    mv.look_at = vec2(0,0)
    mv.manual_camera = false
    mv.sprite_batch = SpriteBatch.new
    mv.game_width = opts[:game_width] || raise(":game_width required")
    mv.game_height = opts[:game_height] || raise(":game_height required")
    mv
  end
end
