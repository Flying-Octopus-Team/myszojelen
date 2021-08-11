extends Control

class_name FocusableContainer

var gui_steering = GUISteering.new()

var should_handle_input : bool = false

func _ready():
	connect("focus_entered", self, "_on_focus_entered")

func show():
	.show()
	grab_focus()


func _on_focus_entered():
	should_handle_input = false
	yield(get_tree().create_timer(0.15), "timeout")
	should_handle_input = true


func _gui_input(event):
	if not should_handle_input:
		return

	if gui_steering.get_action(event) != gui_steering.gui_actions.none and get_node(get_focus_neighbour(MARGIN_BOTTOM)).visible:
		get_node(get_focus_neighbour(MARGIN_BOTTOM)).grab_focus()
	accept_event()
