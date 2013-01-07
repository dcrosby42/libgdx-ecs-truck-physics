
class TruckSystem

  def tick(delta, entity_manager)
    # level = entity_manager.get_all_entities_with_tag("level").first || raise("Can't find the 'level' entity!")
    # input_processor = entity_manager.get_component_of_type(level, MyInputProcessor)

    entities = entity_manager.get_all_entities_with_components_of_type([TruckComponent, PlayerControlComponent])
    entities.each do |e|
      truck_component = entity_manager.get_component_of_type(e, TruckComponent)
      control = entity_manager.get_component_of_type(e, PlayerControlComponent)

      power = 0
      # if input_processor.key_down?(Input::Keys::LEFT)
      if control.left
        power = 100
      elsif control.right
        power = -100
      end
      if power != 0 and control.boost
        truck_component.truck_body.apply_force_to_center Vector2.new(-power,0)
      end
        

      if control.jump
        truck_component.truck_body.apply_force_to_center Vector2.new(-10*power,3000)
        if control.boost
          truck_component.truck_body.apply_angular_impulse 35
        end
      end

      truck_component.motor1.set_motor_speed(power)
      # @motor1.set_max_motor_torque(max_torque)
      truck_component.motor2.set_motor_speed(power)
      # @motor2.set_max_motor_torque(max_torque)
      truck_component.truck_body.apply_torque(0.3*power)
    end
  end
end
