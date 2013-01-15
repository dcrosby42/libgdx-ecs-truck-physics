class Explosion
  attr_accessor :center, :radius, :power
  def initialize(opts)
    @center = opts[:center]
    @power = opts[:power]
    @radius = opts[:radius]
  end

  def covers?(vec)
    # puts "Center #{center.x},#{center.y} radius=#{radius} target #{vec.x},#{vec.y}: distance: #{center.dst(vec)}"
    center.dst(vec) <= radius
  end
end
