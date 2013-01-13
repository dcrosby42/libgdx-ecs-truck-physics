class EntityBuilder
  def create_minecraft_block(entity_manager, opts={})
    MinecraftBlockBuilder.new.build entity_manager, opts
  end

  def self.source_dependencies
    %w{
      physics_builder
      minecraft_block_builder
    }
  end
end
