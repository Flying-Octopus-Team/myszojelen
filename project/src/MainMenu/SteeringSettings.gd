extends VBoxContainer

onready var menu : MenuButton = $HBoxContainer/MenuButton

func _ready() -> void:
	menu.get_popup().connect("id_pressed", self, "_set_steering")
	get_node("HBoxContainer2/BackBtn").connect("pressed", self, "hide")
	get_node("HBoxContainer2/ResetBtn").connect("pressed", SteeringSave, "reset_file")

	_set_menu_text()
	if SteeringSave.steering_type != "none": 
		get_node("Controls"+SteeringSave.steering_type).show()


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
	$"../VBoxContainer".show()


func _set_steering(id: int) -> void:
	var steering_string = menu.get_popup().get_item_text(id)

	if SteeringSave.steering_type != "none": 
		get_node("Controls"+SteeringSave.steering_type).hide()

	menu.text = steering_string

	steering_string = steering_string.replace(" ", "")
	get_node("Controls"+steering_string).show()
	SteeringSave.set_steering_type(steering_string)
