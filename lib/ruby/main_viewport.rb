
class MainViewport
  extend MathUtils
  attr_accessor :camera, :look_at, :zoom_factor, :manual_camera, 
    :sprite_batch, 
    :game_height, :game_width,
    :do_physics_debug_render,
    :do_renderable_renders,
    :follow_body

  def self.create(opts={})
    mv = MainViewport.new
    mv.camera = OrthographicCamera.new
    mv.zoom_factor = 35
    mv.look_at = vec2(0,0)
    mv.manual_camera = false
    mv.sprite_batch = SpriteBatch.new
    mv.game_width = opts[:game_width] || raise(":game_width required")
    mv.game_height = opts[:game_height] || raise(":game_height required")
    mv.do_physics_debug_render = opts[:do_physics_debug_render] || false
    mv.do_renderable_renders = opts[:do_renderable_renders].nil? ? true : opts[:do_renderable_renders]
    mv
  end
end
