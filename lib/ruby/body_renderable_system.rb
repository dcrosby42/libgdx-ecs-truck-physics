
class BodyRenderableSystem
  include MathUtils
  def tick(delta, rend_body_pairs)
    rend_body_pairs.each do |(r, body)|
      r.x = body.position.x - r.center_x
      r.y = body.position.y - r.center_y
      r.angle_degrees = rad2deg(body.angle)
    end
  end
end
