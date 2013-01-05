
class PhysicsComponent
  attr_accessor :world, :step, :velocity_iterations, :position_iterations,
                :debug_renderer, :do_debug_render

  def initialize(opts={})
  end

  def self.create(opts={})
    pc = PhysicsComponent.new

    pc.step = 1.0 / (opts[:framerate] || 60)
    pc.velocity_iterations = 15 
    pc.position_iterations = 15

    gravity = Vector2.new(0,-10)
    do_sleep = true # performance improve: don't simulate resting bodies
    pc.world = World.new(gravity, do_sleep)

    pc.debug_renderer = Box2DDebugRenderer.new
    pc.debug_renderer.setDrawAABBs(false)
    # pc.debug_renderer.draw_aab_bs = true
    pc.debug_renderer.draw_bodies = true
    pc.debug_renderer.draw_inactive_bodies = true

    pc.do_debug_render = opts[:render_debug] || true
    pc
  end
end
