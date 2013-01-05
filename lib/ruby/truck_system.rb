
class TruckSystem

  def tick(delta, entity_manager)
    level = entity_manager.get_all_entities_with_tag("level").first || raise("Can't find the 'level' entity!")
    input_processor = entity_manager.get_component_of_type(level, MyInputProcessor)

    entities = entity_manager.get_all_entities_with_component_of_type(TruckComponent)
    entities.each do |e|
      truck_component = entity_manager.get_component_of_type(e, TruckComponent)

      power = 0
      if input_processor.key_down?(Input::Keys::LEFT)
        power = 100
      elsif input_processor.key_down?(Input::Keys::RIGHT)
        power = -100
      end

      truck_component.motor1.set_motor_speed(power)
      # @motor1.set_max_motor_torque(max_torque)
      truck_component.motor2.set_motor_speed(power)
      # @motor2.set_max_motor_torque(max_torque)
      truck_component.truck_body.apply_torque(0.3*power)
    end
  end
end
