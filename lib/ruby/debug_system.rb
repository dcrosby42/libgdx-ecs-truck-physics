class DebugSystem
  def tick(delta, entity_manager)
    level = entity_manager.get_all_entities_with_tag("level").first || raise("Can't find the 'level' entity!")
    input_processor = entity_manager.get_component_of_type(level, MyInputProcessor)
    hv = entity_manager.get_component_of_type(level, HudViewport)
    
    hv.debug_lines = []
    entities = entity_manager.get_all_entities_with_component_of_type(DebugComponent)
    entities.each do |e|
      dc = entity_manager.get_component_of_type(e, DebugComponent)
      if input_processor.key_pressed?(Input::Keys::F3)
        dc.on = !dc.on
      end
      if dc.on
        dc.debug_items.each do |item|
          comp = nil
          comp = entity_manager.get_component_of_type(e, item.type) if item.type
          value = item.func.call(comp) if comp and item.func
          value = "-" if value.nil?
          hv.debug_lines << "#{item.label}: #{value}"
        end
      end
    end
  end
end
