class DebugSystem
  def tick(delta, entity_manager)
    entities = entity_manager.get_all_entities_with_components_of_type([DebugComponent, HudViewport])
    entities.each do |e|
      dc = entity_manager.get_component_of_type(e, DebugComponent)
      lines = dc.debug_items.map do |item|
        comp = entity_manager.get_component_of_type(e, item.type)
        value = item.func.call(comp) if item.func
        "#{item.label}: #{value}"
      end

      hv = entity_manager.get_component_of_type(e, HudViewport)
      hv.debug_lines = lines

    end
  end
end
