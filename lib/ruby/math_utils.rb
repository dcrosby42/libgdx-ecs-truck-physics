module MathUtils
  RAD_2_DEG = (180 / Math::PI)

  def vec2(x,y)
    Vector2.new(x,y)
  end

  def rad2deg(r)
    r * RAD_2_DEG
  end
end
