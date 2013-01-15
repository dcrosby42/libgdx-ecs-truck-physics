class DebugSystem
  def tick(delta, entity_manager)
    level = entity_manager.get_entity_with_tag("level")
    input_processor = entity_manager.get_component_of_type(level, MyInputProcessor)
    hv              = entity_manager.get_component_of_type(level, HudViewport)
    
    hv.debug_lines = []
    entity_manager.each_entity_with_component_of_type(DebugComponent) do |e, dc|
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
