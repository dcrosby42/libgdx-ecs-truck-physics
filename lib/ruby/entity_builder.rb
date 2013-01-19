class EntityBuilder
  construct_with :entity_manager

  def create_minecraft_block(opts={})
    MinecraftBlockBuilder.new.build entity_manager, opts
  end

  def create_tnt(opts={})
    opts = {
      x: 5, y: 5, radius: 2
    }.merge(opts)
    p opts

    level = entity_manager.get_all_entities_with_tag("level").first || raise("Need 'level' entity")
    physics_component = entity_manager.get_component_of_type(level, PhysicsComponent)

    tnt = create_minecraft_block world: physics_component.world,
      sprite: :tnt,
      controls: {
        :left => [:press, Input::Keys::R],
        :down => [:press, Input::Keys::T],
        :right => [:press, Input::Keys::Y],
        :ignite => [:press, Input::Keys::I],
      },
      x: opts[:x], y: opts[:y]
    entity_manager.add_component tnt, BombComponent.create(
      object_context,
      radius: opts[:radius]
    )
    entity_manager.add_component tnt, DebugComponent.create([
      [ BombComponent, ->(c){c.state}, "Bomb state" ],
      [ BombComponent, ->(c){c.timer}, "Bomb timer" ],
    ])

    return tnt
  end

  def self.source_dependencies
    %w{
      physics_builder
      minecraft_block_builder
    }
  end
end
