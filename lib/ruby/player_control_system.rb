class PlayerControlSystem
  def tick(delta, entity_manager)
    level = entity_manager.get_all_entities_with_tag("level").first || raise("Can't find the 'level' entity!")
    input_processor = entity_manager.get_component_of_type(level, MyInputProcessor)
    
    entity_manager.get_all_components_of_type(PlayerControlComponent).each do |control|
      control.attr_key_mapping.each do |(attr, key_def)|
        gesture,key = key_def
        # p key_def
        val = case gesture
              when :hold
                input_processor.key_down?(key)
              when :press
                input_processor.key_pressed?(key)
              else
                raise("Unknown mode #{mode.inspect}.  Mapping: #{control.attr_key_mapping.inspect}")
              end
        control.send("#{attr}=", val)
      end
    end
  end
end

