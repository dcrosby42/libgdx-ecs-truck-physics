class BombComponent
  attr_accessor :state, :timer, :radius, :power, :fuse_sound, :explode_sound

  def self.create(object_context, opts={})
    sound_loader = object_context[:sound_loader]

    bc = new
    bc.state = :off
    bc.timer = 0
    bc.power = opts[:power] || 100
    bc.radius = opts[:radius] || 2.0
    bc.fuse_sound = sound_loader.load_sound("fizz.ogg")
    bc.explode_sound = sound_loader.load_sound("explode2.ogg")
    bc
  end
end
