class MinecraftBlockBuilder
  include PhysicsBuilder

  construct_with :entity_manager, :texture_loader

  def build(opts={})
    world = opts[:world] || raise("Need :world to build MinecraftBlock")
    tag = opts[:tag] || "minecraft_block"
    controls = opts[:controls] 

    body_x = opts[:x] || 5
    body_y = opts[:y] || 6

    #
    # box w/h
    # friction
    # density
    # restitution
    # groupIndex 

    body = create_dynamic_body world, x: body_x, y: body_y

    fixture = create_polygon_fixture body, 
      width: 2.0, height: 2.0, 
      friction: 0.3, 
      density: 0.5, 
      restitution: 0.1

    # debug messing
    # fixture = create_polygon_fixture body, 
    #   points: vec2_array([
    #     [0,0],
    #     [2,0],
    #     [2,2],
    #     [0,2],
    #   ]),
    #   friction: 0.3, 
    #   density: 0.5, 
    #   restitution: 0.1


    tex = texture_loader.load_texture('minecraft_sheet.png')
    row = 2
    col = 11
    case opts[:sprite]
    when Array
      col, row = opts[:sprite]
    when Symbol
      col, row = lookup_minecraft_texture_sprite(opts[:sprite])
    end

    body_renderable = BodyRenderable.create(texture: tex, 
                                  texture_scale: 0.008, 
                                  offset_x: 0.0, offset_y: 0.0,
                                  source_x: col*16, source_y: row*16,
                                  source_width: 16, source_height: 16,

                                  body: body
                                 )
    # tex fname
    # tex scale: scale multiplier to size the image to the environment. 
    # offset_x and offset_uy -- center of box, 0,0 means math center of the box (this is default)
    # source x/y: where in the text to start taking from (lower left), measured in pixels in the image
    # source w/h: how much of the source tex to use, reaching up and right from the lower left specified by source x/y, measured in pixels in the image

    minecraft_block = MinecraftBlock.new
    minecraft_block.body = body
    # mb.renderable = body_rend

    $tnt = body

    entity = entity_manager.create_tagged_entity(tag)
    entity_manager.add_component entity, minecraft_block
    entity_manager.add_component entity, body_renderable
    if controls
      entity_manager.add_component entity, ControlComponent.create(controls)
    end

    entity
  end


  def lookup_minecraft_texture_sprite(sym)
    lookup = {
      pumpkin: [7,7],
      pumpkin_side: [6,7],
      pumpkin_top: [6,6],
      jack_o_lantern: [8,7],
      crafting_table: [11,2],
      crafting_table_side: [11,3],
      crafting_table_front: [12,3],
      tnt: [8,0],
      brick: [7,0],
      dirt: [2,0],
      grass: [3,0],
      cobblestone: [0,1],
    }
    lookup[sym] || lookup[:crafting_block_top]
  end
end
