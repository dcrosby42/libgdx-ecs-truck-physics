
class Renderable 
  attr_accessor :texture,
    :texture_scale,
    :center_x, :center_y,
    :offset_x, :offset_y,
    :x, :y,
    :origin_x, :origin_y,
    :width, :height,
    :scale_x, :scale_y,
    :angle_degrees,
    :source_x, :source_y,
    :source_width, :source_height,
    :flip_x, :flip_y

  def self.create(opts={})
    r = Renderable.new
    r.texture = opts[:texture] || raise("Texture required")
    texture_scale = opts[:texture_scale] || 1.0
    r.width = texture_scale * r.texture.width
    r.height = texture_scale * r.texture.height
    r.center_x = r.width / 2.0 - (opts[:offset_x] || 0.0)
    r.center_y = r.height / 2.0 - (opts[:offset_y] || 0.0)
    r.x = 0
    r.y = 0
    r.origin_x = r.center_x
    r.origin_y = r.center_y
    r.scale_x = 1.0
    r.scale_y = 1.0
    r.angle_degrees = 0
    r.source_x = 0
    r.source_y = 0
    r.source_width = r.texture.width
    r.source_height = r.texture.height
    r.flip_x = false
    r.flip_y = false
    r
  end
end
