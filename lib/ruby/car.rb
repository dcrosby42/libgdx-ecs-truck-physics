
class Car
  include Screen

  def show
    return if @broke

    # @input_processor = DebugInputProcessor.new
    @input_processor = MyInputProcessor.new
    Gdx.input.setInputProcessor @input_processor

    #
    # COMPONENTS: 
    #

    @physics_component = PhysicsComponent.create

    @main_viewport = MainViewport.create(game_width: $game_width, game_height: $game_height)

    GroundComponent.create(@physics_component.world)
    
    @truck_component = TruckComponent.create(@physics_component.world)
    @main_viewport.follow_body = @truck_component.truck_body # FIXME

    @hud_viewport = HudViewport.create(game_width: $game_width, game_height: $game_height)

    #
    # SYSTEMS: 
    #
    
    @physics_system = PhysicsSystem.new
    @truck_system = TruckSystem.new
    @body_renderable_system = BodyRenderableSystem.new
    @main_viewport_system = MainViewportSystem.new
    @hud_viewport_system = HudViewportSystem.new
    
    @main_rendering_system = MainRenderingSystem.new
    @physics_debug_rendering_system = PhysicsDebugRenderingSystem.new
    @hud_rendering_system = HudRenderingSystem.new

  rescue Exception => e
    debug_exception e
    @broke = true
  end

  def render(delta)
    # Level / reload control:
    reload_car if @input_processor.key_pressed?(Input::Keys::BACKSLASH)
    Gdx.app.exit if @input_processor.key_pressed?(Input::Keys::ESCAPE)
    return if @broke

    #
    # UPDATING
    #

    @truck_system.tick(delta, @truck_component, @input_processor)
    
    @physics_system.tick(delta, @physics_component)

    @main_viewport_system.tick(delta, @main_viewport, @input_processor)

    @hud_viewport_system.tick(delta, @hud_viewport)

    @body_renderable_system.tick(delta, [
      [@truck_component.wheel1_rend, @truck_component.wheel1],
      [@truck_component.wheel2_rend, @truck_component.wheel2],
      [@truck_component.truck_body_rend, @truck_component.truck_body],
    ])

    @input_processor.clear

    #
    # RENDERING
    #

    Gdx.gl.glClear(GL10::GL_COLOR_BUFFER_BIT);  

    @main_rendering_system.tick(delta, @main_viewport, [
      @truck_component.wheel1_rend,
      @truck_component.wheel2_rend,
      @truck_component.truck_body_rend,
    ])

    @physics_debug_rendering_system.tick delta, @physics_component, @main_viewport

    @hud_rendering_system.tick(delta, @hud_viewport)

  rescue Exception => e
    debug_exception e
    @broke = true
  end

  def hide
  end

  def resize(w,h)
  end

  def pause
  end

  def resume
  end

  def dispose
  end

  # class ControlState
  #   attr_accessor :toggle_hud
  # end



  def self.source_dependencies
    %w{
      my_input_processor

      physics_component
      physics_system
      main_viewport
      hud_viewport
      truck_component
      truck_system
      renderable
      body_renderable_system
      main_rendering_system

      main_viewport_system
      hud_viewport_system
      physics_debug_rendering_system
      hud_rendering_system
      ground_component
    }
  end
end



