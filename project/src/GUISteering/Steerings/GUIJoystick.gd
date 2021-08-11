extends GUIBaseSteeringScript

class_name GUIJoystick

const JOY_SENSITIVITY := 0.5 
const ONE_FOURTH_PI = PI / 4.0

func get_action(event, gui_enum) -> int:
	if event is InputEventJoypadButton and event.button_index == InputMap.get_action_list("shot_pad")[0].button_index:
		return gui_enum.press

	if not event is InputEventJoypadMotion:
		return gui_enum.none
	
	if event.get_axis() == JOY_AXIS_0 and event.get_axis_value() > 0.5:
		return gui_enum.right
	elif event.get_axis() == JOY_AXIS_0 and event.get_axis_value() < -0.5:
		return gui_enum.left
	elif event.get_axis() == JOY_AXIS_1 and event.get_axis_value() > 0.5:
		return gui_enum.down
	elif event.get_axis() == JOY_AXIS_1 and event.get_axis_value() < -0.5:
		return gui_enum.up

	return gui_enum.none
