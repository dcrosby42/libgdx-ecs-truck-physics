
class HudViewport
  attr_accessor :camera, :sprite_batch, :font, :game_height, :game_width

  def self.create(opts={})
    hv = HudViewport.new
    hv.camera = OrthographicCamera.new
    hv.game_width = opts[:game_width] || raise(":game_width required")
    hv.game_height = opts[:game_height] || raise(":game_height required")
    hv.camera.viewportWidth = hv.game_width
    hv.camera.viewportHeight = hv.game_height
    hv.camera.position.set(hv.camera.viewportWidth * 0.5, hv.camera.viewportHeight * 0.5, 0)
    hv.camera.update

    hv.sprite_batch = SpriteBatch.new
    hv.font = BitmapFont.new
    hv
  end
end
