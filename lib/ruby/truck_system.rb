
class TruckSystem

  def tick(delta, entity_manager)
    entity_manager.each_entity_with_components_of_type([TruckComponent, ControlComponent]) do |e, truck_component, control|

      power = 0
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
