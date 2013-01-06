class StatsComponent
  attr_accessor :fps, :time_per_loop, :expected_framerate, :utilization
  def self.create
    sc = new
    sc.fps = nil
    sc.time_per_loop = nil
    sc
  end
end
