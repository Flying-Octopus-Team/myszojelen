extends Button

export var action_name : String

var pressed_button : bool = false

var delayed_input : bool = false

func _ready() -> void:
	var action_list = InputMap.get_action_list(action_name)
	if not action_list.empty():
		name_button(action_list[0])
		

func name_button(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		text = tr("BUTTON_KEY") + " " + str(event.button_index)
	else:
		text = event.as_text()


func _pressed() -> void:
	if delayed_input:
		return
	_disable_all_buttons()
	_enable()


func _input(event):
	if event is InputEventKey and pressed_button:
		get_tree().set_input_as_handled()

		if not event.is_action("ui_cancel"):
			_add_new_keybind_to_inputmap(event)

			SteeringSave.save_input()

		pressed_button = false
		_block_next_input_for_parent()

	elif event is InputEventJoypadButton and pressed_button:
		get_tree().set_input_as_handled()
		set_process_input(false)

		if not event.is_action("ui_cancel"):
			_add_new_pad_keybind_to_inputmap(event)

			SteeringSave.save_input()
		pressed_button = false
		_block_next_input_for_parent()


func _block_next_input_for_parent() -> void:
	$"../".should_handle_input = false
	yield(get_tree().create_timer(0.15), "timeout")
	$"../".should_handle_input = true

func _add_new_keybind_to_inputmap(event: InputEventKey) -> void:
	var scancode = OS.get_scancode_string(event.scancode)
	text = scancode

	var action_list = InputMap.get_action_list(action_name)

	if not action_list.empty():
		InputMap.action_erase_event(action_name, action_list[0])
	InputMap.action_add_event(action_name, event)
	
	_erase_keybind_from_other_actions(scancode)


func _add_new_pad_keybind_to_inputmap(event: InputEventJoypadButton) -> void:
	text = tr("BUTTON_KEY") + " " + str(event.button_index)

	var action_list = InputMap.get_action_list(action_name)

	if not action_list.empty():
		InputMap.action_erase_event(action_name, action_list[0])
	InputMap.action_add_event(action_name, event)


func _erase_keybind_from_other_actions(scancode: String) -> void:
	for other_action_hbox in $"../../".get_children():
		for other_action in other_action_hbox.get_children():
			if not other_action is Button or other_action == self or other_action.text != scancode:
				continue

			other_action.text = ""
			InputMap.action_erase_event(other_action.action_name, InputMap.get_action_list(other_action.action_name)[0])


func _enable() -> void:
	text = ">"+text+"<"
	delayed_input = true
	yield(get_tree().create_timer(0.15), "timeout")

	pressed_button = true
	delayed_input = false

		
func disable() -> void:
	if pressed_button == true:
		pressed_button = false
		text = text.substr(1, text.length()-2)


func _disable_all_buttons() -> void:
	for action_hbox in $"../../".get_children():
		for button in action_hbox.get_children():
			if button is Button:
				button.disable()


func handle_action(action: int) -> void:
	if action == GUISteering.gui_actions.left or action == GUISteering.gui_actions.right:
		return

	_pressed()
