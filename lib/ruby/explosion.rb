class Explosion
  attr_accessor :center, :radius, :power
  def initialize(opts)
    @center = opts[:center]
    @power = opts[:power]
    @radius = opts[:radius]
  end
end
