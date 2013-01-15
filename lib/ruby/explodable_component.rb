class ExplodableComponent
  attr_reader :explosions

  def initialize
    @explosions = []
  end
  
  def add(explosion)
    @explosions << explosion
  end

  def clear
    @explosions.clear
  end

  def explosion?
    !@explosions.empty?
  end

  def self.create
    new
  end
end
