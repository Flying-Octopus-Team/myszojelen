extends FocusableContainer

onready var menu : Button = $MenuButtonContainer/MenuButton

func _ready() -> void:
	menu.connect("id_pressed", self, "_set_steering")
	get_node("HBoxContainer2/BackBtnContainer/BackBtn").connect("pressed", self, "hide")
	get_node("HBoxContainer2/ResetBtnContainer/ResetBtn").connect("pressed", SteeringSave, "reset_file")

	update_controls_menu()


func update_controls_menu() -> void:
	_set_menu_text()
	if SteeringSave.steering_type != "none": 
		get_node("Controls"+SteeringSave.steering_type).show()

	_connect_menu_button_to_container(SteeringSave.steering_type)


func _set_menu_text() -> void:
	match SteeringSave.steering_type:
		"4Directions":
			menu.text = "4 Directions"
		"8Directions":
			menu.text = "8 Directions"
		"VirtualPad":
			menu.text = "Virtual Pad"
		"Pad":
			menu.text = "Pad"
		"Rotations":
			menu.text = "Rotations"
		_:
			menu.text = "None"


func hide() -> void:
	.hide()
	$"../MainSettings".show()


func _set_steering(steering_string: String) -> void:

	if SteeringSave.steering_type != "none": 
		get_node("Controls"+SteeringSave.steering_type).hide()

	menu.text = steering_string

	steering_string = steering_string.replace(" ", "")
	get_node("Controls"+steering_string).show()
	SteeringSave.set_steering_type(steering_string)

	_connect_menu_button_to_container(steering_string)


func _connect_menu_button_to_container(steering_type: String) -> void:
	if steering_type == "none":
		$MenuButtonContainer.focus_neighbour_bottom = get_node("HBoxContainer2/BackBtnContainer").get_path()
		get_node("HBoxContainer2/BackBtnContainer").focus_neighbour_top = $MenuButtonContainer.get_path()
		get_node("HBoxContainer2/ResetBtnContainer").focus_neighbour_top = $MenuButtonContainer.get_path()
		return

	var path_to_container : String = "Controls"+steering_type
	if steering_type == "8Directions":
		path_to_container += "/VBoxContainer"

	$MenuButtonContainer.focus_neighbour_bottom = get_node(path_to_container).get_child(0).get_path()
	get_node(path_to_container).get_child(0).focus_neighbour_top = $MenuButtonContainer.get_path()

	get_node("HBoxContainer2/BackBtnContainer").focus_neighbour_top = get_node(path_to_container).get_child(get_node(path_to_container).get_child_count()-1).get_path()
	get_node("HBoxContainer2/ResetBtnContainer").focus_neighbour_top = get_node(path_to_container).get_child(get_node(path_to_container).get_child_count()-1).get_path()
