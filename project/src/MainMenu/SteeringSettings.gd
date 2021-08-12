extends FocusableContainer

onready var menu : Button = $MenuButtonContainer/MenuButton

func _ready() -> void:
	menu.connect("id_pressed", self, "_set_steering")
	get_node("HBoxContainer2/BackBtnContainer/BackBtn").connect("pressed", self, "hide")
	get_node("HBoxContainer2/ResetBtnContainer/ResetBtn").connect("pressed", SteeringSave, "reset_file")

	update_controls_menu()


func update_controls_menu() -> void:
	menu.text = tr(SteeringSave.steering_type+"_KEY")
	if SteeringSave.steering_type != "none": 
		get_node("Controls"+SteeringSave.steering_type).show()

	_connect_menu_button_to_container(SteeringSave.steering_type)


func hide() -> void:
	.hide()
	$"../MainSettings".show()


func _set_steering(steering_string: String) -> void:

	if SteeringSave.steering_type != "none": 
		get_node("Controls"+SteeringSave.steering_type).hide()

	steering_string = steering_string.replace(" ", "")
	get_node("Controls"+steering_string).show()
	SteeringSave.set_steering_type(steering_string)

	menu.text = tr(SteeringSave.steering_type+"_KEY")

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

	if steering_type == "VirtualPad":
		$MenuButtonContainer.focus_neighbour_bottom = get_node("HBoxContainer2/BackBtnContainer").get_path()
		get_node("HBoxContainer2/BackBtnContainer").focus_neighbour_top = $MenuButtonContainer.get_path()
		get_node("HBoxContainer2/ResetBtnContainer").focus_neighbour_top = $MenuButtonContainer.get_path()
	else:
		$MenuButtonContainer.focus_neighbour_bottom = get_node(path_to_container).get_child(0).get_path()

		get_node("HBoxContainer2/BackBtnContainer").focus_neighbour_top = get_node(path_to_container).get_child(get_node(path_to_container).get_child_count()-1).get_path()
		get_node("HBoxContainer2/ResetBtnContainer").focus_neighbour_top = get_node(path_to_container).get_child(get_node(path_to_container).get_child_count()-1).get_path()
