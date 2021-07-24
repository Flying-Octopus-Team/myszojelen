extends VBoxContainer

class_name FocusableVBoxContainer

var gui_steering = GUISteering.new()

func show():
	.show()
	grab_focus()

func _gui_input(event):
	if gui_steering.get_action(event) != gui_steering.gui_actions.none:
		get_node(get_focus_neighbour(MARGIN_BOTTOM)).grab_focus()
	accept_event()
