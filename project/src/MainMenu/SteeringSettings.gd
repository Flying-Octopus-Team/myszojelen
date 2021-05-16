extends VBoxContainer

onready var menu : MenuButton = $HBoxContainer/MenuButton

func _ready() -> void:
	menu.get_popup().connect("id_pressed", self, "_set_steering")
	get_node("BackBtn").connect("pressed", self, "hide")

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
	if SteeringSave.steering_type != "none": 
		get_node("Controls"+SteeringSave.steering_type).show()


func hide() -> void:
	.hide()
	$"../VBoxContainer".show()


func _set_steering(id: int) -> void:
	var steering_string = menu.get_popup().get_item_text(id)

	if SteeringSave.steering_type != "none": 
		get_node("Controls"+SteeringSave.steering_type).hide()

	menu.text = steering_string
	match steering_string:
		"4 Directions":
			get_node("Controls4Directions").show()
			SteeringSave.set_steering_type("4Directions")
		"8 Directions":
			get_node("Controls8Directions").show()
			SteeringSave.set_steering_type("8Directions")
		"Pad":
			get_node("ControlsPad").show()
			SteeringSave.set_steering_type("Pad")
		"Rotations":
			get_node("ControlsRotations").show()
			SteeringSave.set_steering_type("Rotations")
		"Virtual Pad":
			SteeringSave.set_steering_type("VirtualPad")
