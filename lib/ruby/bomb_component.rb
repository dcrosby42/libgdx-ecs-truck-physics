class BombComponent
  attr_accessor :state, :timer, :radius, :power, :fuse_sound, :explode_sound
  def self.create(opts={})
    bc = new
    bc.state = :off
    bc.timer = 0
    bc.power = opts[:power] || 100
    bc.radius = opts[:radius] || 2.0
    bc.fuse_sound = load_sound("fizz.ogg")
    bc.explode_sound = load_sound("explode2.ogg")
    bc
  end
end
