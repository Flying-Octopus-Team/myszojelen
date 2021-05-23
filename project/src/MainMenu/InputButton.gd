extends Button

export var action_name : String

var pressed_button : bool = false

func _ready() -> void:
	var action_list = InputMap.get_action_list(action_name)
	if not action_list.empty():
		var event = action_list[0]
		if event is InputEventJoypadButton:
			text = "Button " + str(event.button_index)
		else:
			text = event.as_text()


func _pressed() -> void:
	for action_hbox in $"../../".get_children():
		for button in action_hbox.get_children():
			if button is Button:
				button.disable()
	text = ">"+text+"<"
	set_process_input(true)
	pressed_button = true


func _input(event):
	if event is InputEventKey and pressed_button:
		get_tree().set_input_as_handled()
		set_process_input(false)

		if not event.is_action("ui_cancel"):
			var scancode = OS.get_scancode_string(event.scancode)
			text = scancode

			var action_list = InputMap.get_action_list(action_name)

			if not action_list.empty():
				InputMap.action_erase_event(action_name, action_list[0])
			InputMap.action_add_event(action_name, event)
			
			for other_action_hbox in $"../../".get_children():
				for other_action in other_action_hbox.get_children():
					if not other_action is Button or other_action == self or other_action.text != scancode:
						continue

					other_action.text = ""
					InputMap.action_erase_event(other_action.action_name, InputMap.get_action_list(other_action.action_name)[0])

			SteeringSave.save_input()
		pressed_button = false
	elif event is InputEventJoypadButton and pressed_button:
		get_tree().set_input_as_handled()
		set_process_input(false)

		if not event.is_action("ui_cancel"):
			text = "Button " + str(event.button_index)

			var action_list = InputMap.get_action_list(action_name)

			if not action_list.empty():
				InputMap.action_erase_event(action_name, action_list[0])
			InputMap.action_add_event(action_name, event)

			SteeringSave.save_input()
		pressed_button = false

		
func disable() -> void:
	if pressed_button == true:
		set_process_input(false)
		pressed_button = false
		text = text.substr(1, text.length()-2)
