
class SandboxScreen
  include Screen

  construct_with :app_shell, :entity_manager, :entity_builder

  def initialize
    # @app_shell = opts[:app_shell]
    # @game_width = opts[:game_width]
    # @game_height = opts[:game_height]
    @game_width = app_shell.game_width
    @game_height = app_shell.game_height
  end

  def show
    return if @broke

    # @input_processor = DebugInputProcessor.new
    @input_processor = MyInputProcessor.new
    Gdx.input.setInputProcessor @input_processor

    #
    # COMPONENTS: 
    #

    # Physics:
    physics_component = PhysicsComponent.create(framerate: 60)

    # Game perf stats:
    @stats_component = StatsComponent.create
    @stats_component.expected_framerate = 60
    
    # The "Level": 
    level = entity_manager.create_tagged_entity('level')
    entity_manager.add_component level, physics_component
    entity_manager.add_component level, GroundComponent.create(object_context, physics_component.world)
    entity_manager.add_component level, ExplodableComponent.create
    entity_manager.add_component level, @input_processor 
    entity_manager.add_component level, MainViewport.create(game_width: @game_width, game_height: @game_height, 
                                                             do_physics_debug_render: true,
                                                             do_renderable_renders: true,
                                                             zoom_factor: 20,
                                                             follow_player: 'player1')
    entity_manager.add_component level, DemolitionComponent.create
    entity_manager.add_component level, ControlComponent.create({
      :zoom_out   => [ :hold,  Input::Keys::MINUS ],
      :zoom_in    => [ :hold,  Input::Keys::EQUALS ],
      :pan_left   => [ :hold,  Input::Keys::NUM_9 ],
      :pan_right  => [ :hold,  Input::Keys::NUM_0 ],
      :drop_tnt   => [ :press,  Input::Keys::P ],
      :toggle_draw_physics      => [ :press,  Input::Keys::F1 ],
      :toggle_draw_renderables  => [ :press,  Input::Keys::F2 ],
      :toggle_follow_player     => [ :press,  Input::Keys::F4 ],
    })
    hud_viewport = HudViewport.create(game_width: @game_width, game_height: @game_height)
    entity_manager.add_component level, hud_viewport
    entity_manager.add_component level, @stats_component
    entity_manager.add_component level, DebugComponent.create([
      [ StatsComponent, ->(c){c.fps}, "FPS" ],
      # [ StatsComponent, ->(c){c.time_per_loop}, "Time-per-loop" ],
      [ StatsComponent, ->(c){c.utilization}, "Render load" ],
      # [ MainViewport, ->(c){c.zoom_factor}, "Zoom" ],
      [ MainViewport, ->(c){c.follow_player}, "Following" ],
    ])

    # Player 1 Truck
    truck_component = TruckComponent.create(object_context, world: physics_component.world)
    player1 = entity_manager.create_tagged_entity('player1')
    entity_manager.add_component player1, truck_component
    entity_manager.add_component player1, ControlComponent.create({
      :left  => [ :hold,  Input::Keys::A ],
      :right => [ :hold,  Input::Keys::D ], 
      :jump  => [ :press, Input::Keys::W ], 
      :boost => [ :hold,  Input::Keys::CONTROL_LEFT ],
    })
    # entity_manager.add_component player1, DebugComponent.create([
    #   [ TruckComponent, ->(c){c.wheel2.angle}, "Wheel2 angle" ],
    #   [ TruckComponent, ->(c){c.wheel1.angle}, "Wheel1 angle" ],
    # ])
    entity_manager.add_component player1, ExplodableComponent.create

    # Player 2 Truck
    truck_component2 = TruckComponent.create(object_context, world: physics_component.world, x: 15)
    player2 = entity_manager.create_tagged_entity('player2')
    entity_manager.add_component player2, truck_component2
    entity_manager.add_component player2, ControlComponent.create({
      :left  => [ :hold,  Input::Keys::LEFT ],
      :right => [ :hold,  Input::Keys::RIGHT ], 
      :jump  => [ :press, Input::Keys::UP ], 
      :boost => [ :hold,  Input::Keys::SHIFT_RIGHT ],
    })
    entity_manager.add_component player2, DebugComponent.create([
      # [ TruckComponent, ->(c){c.wheel2.angle}, "Wheel2 angle" ],
      # [ TruckComponent, ->(c){c.wheel1.angle}, "Wheel1 angle" ],
      # [ ControlComponent, ->(c){c.left}, "P2 left?" ],
      # [ ControlComponent, ->(c){c.right}, "P2 right?" ],
      # [ ControlComponent, ->(c){c.jump}, "P2 jump?" ],
      # [ ControlComponent, ->(c){c.boost}, "P2 boost?" ],
    ])
    entity_manager.add_component player2, ExplodableComponent.create

    entity_builder.create_tnt x: 13, y: 10, radius: 7

    #
    # SYSTEMS: 
    #

    # (ordering is significant)
    @update_systems = [
      # Updating:
      ControlSystem.new,
      TruckSystem.new,
      MinecraftBlockSystem.new,
      BombSystem.new,
      ExplodableTruckSystem.new,
      ExplodableStoneSystem.new,
      PhysicsSystem.new,
      MainViewportSystem.new,
      StatsSystem.new,
      DebugSystem.new,
      HudViewportSystem.new,
      BodyRenderableSystem.new,
      DemolitionSystem.new,
    ]

    @render_systems = [
      # Rendering:
      MainRenderingSystem.new,
      PhysicsDebugRenderingSystem.new,
      HudRenderingSystem.new,
    ]

    @play_systems = @update_systems + @render_systems
    @pause_systems = @render_systems + [PauseRenderingSystem.new]

    @paused_by_user = false

  rescue Exception => e
    debug_exception e
    @broke = true
  end


  def render(delta)
    render_start_time = Time.now
    # Level / reload control:
    app_shell.reload_game_screen if @input_processor.key_pressed?(Input::Keys::BACKSLASH)
    Gdx.app.exit if @input_processor.key_pressed?(Input::Keys::ESCAPE)
    if @input_processor.key_pressed?(Input::Keys::SPACE)
      @paused_by_user = !@paused_by_user
    end
    
    return if @broke

    Gdx.gl.glClear(GL10::GL_COLOR_BUFFER_BIT);  

    if @paused_by_user
      @pause_systems.each do |system|
        system.tick delta, entity_manager
      end
    else
      @play_systems.each do |system|
        system.tick delta, entity_manager
      end
    end
  
    @input_processor.clear
    render_end_time = Time.now
    @stats_component.time_per_loop = render_end_time.to_f - render_start_time.to_f

  rescue Exception => e
    debug_exception e
    @broke = true
  end

  def hide
  end

  def resize(w,h)
    puts "Resized to #{w}x#{h}"
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
      entity_builder
      my_input_processor
      sound_loader
      texture_loader

      physics_component
      physics_system
      main_viewport
      hud_viewport
      truck_component
      truck_system
      explosion
      explodable_component
      explodable_truck_system
      explodable_stone_system
      minecraft_block_system
      minecraft_block
      bomb_component
      bomb_system
      control_component
      control_system
      body_renderable
      body_renderable_system
      main_rendering_system

      main_viewport_system
      hud_viewport_system
      physics_debug_rendering_system
      hud_rendering_system
      pause_rendering_system
      ground_component
      demolition_component
      demolition_system

      debug_component
      debug_system

      stats_component
      stats_system
    }
  end
end



