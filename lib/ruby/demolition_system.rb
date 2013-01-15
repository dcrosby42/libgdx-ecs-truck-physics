class DemolitionSystem
  def tick(delta,entity_manager)
    entities = entity_manager.get_all_entities_with_components_of_type([DemolitionComponent, ControlComponent])
    entities.each do |e|
      control = entity_manager.get_component_of_type(e, ControlComponent)
      if control.drop_tnt
        entity_manager.builder.create_tnt(x: 13, y: 10, radius: 7)
      end
    end
  end
end
