module MathUtils
  RAD_2_DEG = (180 / Math::PI)

  def vec2(x,y)
    Vector2.new(x,y)
  end

  def vec2_array(pairs)
    pairs.map(&->(x,y) { vec2(x,y) }).to_java(Vector2)
  end

  def rad2deg(r)
    r * RAD_2_DEG
  end
end
