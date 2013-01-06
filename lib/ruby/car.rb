
class Car
  include Screen

  def show
    return if @broke

    # @input_processor = DebugInputProcessor.new
    @input_processor = MyInputProcessor.new
    Gdx.input.setInputProcessor @input_processor

    @entity_manager = EntityManager.new

    #
    # COMPONENTS: 
    #

    physics_component = PhysicsComponent.create(framerate: 60)
    level = @entity_manager.create_tagged_entity('level')
    @entity_manager.add_component level, physics_component
    @entity_manager.add_component level, GroundComponent.create(physics_component.world)
    @entity_manager.add_component level, @input_processor # FIXME???
    

    main_viewport = MainViewport.create(game_width: $game_width, game_height: $game_height, do_physics_debug_render: true)
    hud_viewport = HudViewport.create(game_width: $game_width, game_height: $game_height)

    truck_component = TruckComponent.create(world: physics_component.world)
    main_viewport.follow_body = truck_component.truck_body # FIXME

    player1 = @entity_manager.create_tagged_entity('player1')
    @entity_manager.add_component player1, main_viewport
    @entity_manager.add_component player1, hud_viewport
    @entity_manager.add_component player1, truck_component
    @entity_manager.add_component player1, DebugComponent.create([
      [ TruckComponent, ->(c){c.wheel1.angle}, "Wheel1 angle" ],
    ])

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
    @debug_system = DebugSystem.new

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

    @truck_system.tick delta, @entity_manager 
    
    @physics_system.tick delta, @entity_manager 

    @main_viewport_system.tick delta, @entity_manager 
    
    @debug_system.tick delta, @entity_manager 
    
    @hud_viewport_system.tick delta, @entity_manager 

    @body_renderable_system.tick delta, @entity_manager 

    @input_processor.clear

    #
    # RENDERING
    #

    Gdx.gl.glClear(GL10::GL_COLOR_BUFFER_BIT);  

    @main_rendering_system.tick delta, @entity_manager

    @physics_debug_rendering_system.tick delta, @entity_manager

    @hud_rendering_system.tick delta, @entity_manager

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

  def self.source_dependencies
    %w{
      entity_manager
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

      debug_component
      debug_system
    }
  end
end



