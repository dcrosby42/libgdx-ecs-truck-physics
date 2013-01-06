class DebugSystem
  def tick(delta, entity_manager)
    level = entity_manager.get_all_entities_with_tag("level").first || raise("Can't find the 'level' entity!")
    input_processor = entity_manager.get_component_of_type(level, MyInputProcessor)
    
    entities = entity_manager.get_all_entities_with_components_of_type([DebugComponent, HudViewport])
    entities.each do |e|
      dc = entity_manager.get_component_of_type(e, DebugComponent)
      hv = entity_manager.get_component_of_type(e, HudViewport)
      if input_processor.key_pressed?(Input::Keys::F3)
        dc.on = !dc.on
      end
      if dc.on
        lines = dc.debug_items.map do |item|
          comp = entity_manager.get_component_of_type(e, item.type)
          value = item.func.call(comp) if item.func
          "#{item.label}: #{value}"
        end

        hv.debug_lines = lines
      else
        hv.debug_lines = []
      end
    end
  end
end
