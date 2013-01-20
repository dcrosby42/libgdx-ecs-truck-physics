class DemolitionSystem
  def tick(delta,entity_manager)
    entity_manager.each_entity_with_components_of_type([DemolitionComponent, ControlComponent]) do |e,_,control|
      control = entity_manager.get_component_of_type(e, ControlComponent)
      if control.drop_tnt
        entity_manager.entity_builder.create_tnt(x: 13, y: 10, radius: 7)
      end
    end
  end
end
