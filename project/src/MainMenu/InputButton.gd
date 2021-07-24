extends Button

export var action_name : String

var pressed_button : bool = false

func _ready() -> void:
	var action_list = InputMap.get_action_list(action_name)
	if not action_list.empty():
		_name_button(action_list[0])
		

func _name_button(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		text = "Button " + str(event.button_index)
	else:
		text = event.as_text()


func _pressed() -> void:
	_disable_all_buttons()
	_enable()


func _input(event):
	if event is InputEventKey and pressed_button:
		get_tree().set_input_as_handled()
		set_process_input(false)

		if not event.is_action("ui_cancel"):
			_add_new_keybind_to_inputmap(event)

			SteeringSave.save_input()

		pressed_button = false
	elif event is InputEventJoypadButton and pressed_button:
		get_tree().set_input_as_handled()
		set_process_input(false)

		if not event.is_action("ui_cancel"):
			_add_new_pad_keybind_to_inputmap(event)

			SteeringSave.save_input()
		pressed_button = false


func _add_new_keybind_to_inputmap(event: InputEventKey) -> void:
	var scancode = OS.get_scancode_string(event.scancode)
	text = scancode

	var action_list = InputMap.get_action_list(action_name)

	if not action_list.empty():
		InputMap.action_erase_event(action_name, action_list[0])
	InputMap.action_add_event(action_name, event)
	
	_erase_keybind_from_other_actions(scancode)


func _add_new_pad_keybind_to_inputmap(event: InputEventJoypadButton) -> void:
	text = "Button " + str(event.button_index)

	var action_list = InputMap.get_action_list(action_name)

	if not action_list.empty():
		InputMap.action_erase_event(action_name, action_list[0])
	InputMap.action_add_event(action_name, event)

	_erase_keybind_from_other_actions("Button " + str(event.button_index))


func _erase_keybind_from_other_actions(scancode: String) -> void:
	for other_action_hbox in $"../../".get_children():
		for other_action in other_action_hbox.get_children():
			if not other_action is Button or other_action == self or other_action.text != scancode:
				continue

			other_action.text = ""
			InputMap.action_erase_event(other_action.action_name, InputMap.get_action_list(other_action.action_name)[0])


func _enable() -> void:
	text = ">"+text+"<"
	set_process_input(true)
	pressed_button = true

		
func disable() -> void:
	if pressed_button == true:
		set_process_input(false)
		pressed_button = false
		text = text.substr(1, text.length()-2)


func _disable_all_buttons() -> void:
	for action_hbox in $"../../".get_children():
		for button in action_hbox.get_children():
			if button is Button:
				button.disable()


func handle_on_focus_entered() -> void:
	set_scale(Vector2(1.3, 1.3))

func handle_on_focus_exited() -> void:
	set_scale(Vector2.ONE)

func handle_action(action: int) -> void:
	if action == GUISteering.gui_actions.left or action == GUISteering.gui_actions.right:
		return

	emit_signal("pressed")
