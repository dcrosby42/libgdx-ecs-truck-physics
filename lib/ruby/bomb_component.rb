class BombComponent
  attr_accessor :state, :timer, :radius, :power
  def self.create(opts={})
    bc = new
    bc.state = :off
    bc.timer = 0
    bc.power = 100
    bc.radius = 2.0
    bc
  end
end
