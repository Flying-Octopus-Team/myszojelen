extends HBoxContainer

class_name SteerableContainer

var should_handle_input : bool = true

var gui_steering = GUISteering.new()

func _ready():
	connect("focus_entered", self, "_on_focus_entered")
	connect("focus_exited", self, "_on_focus_exited")

	Settings.connect("audio_effects_volume_changed", self, "set_audio_volume")
	set_audio_volume(Settings.audio_effects_volume)

func _gui_input(event):
	accept_event()

	if not should_handle_input:
		return
		
	if event is InputEventMouseMotion and not has_focus():
		grab_focus()

	_match_input_event(gui_steering.get_action(event))

func _match_input_event(event):

	match event:
		gui_steering.gui_actions.down:
			get_node(get_focus_neighbour(MARGIN_BOTTOM)).grab_focus()

		gui_steering.gui_actions.up:
			get_node(get_focus_neighbour(MARGIN_TOP)).grab_focus()

		gui_steering.gui_actions.left:
			if get_focus_neighbour(MARGIN_LEFT) != "":
				get_node(get_focus_neighbour(MARGIN_LEFT)).grab_focus()
			else:
				get_action_child().handle_action(gui_steering.gui_actions.left)

		gui_steering.gui_actions.right:
			if get_focus_neighbour(MARGIN_RIGHT):
				get_node(get_focus_neighbour(MARGIN_RIGHT)).grab_focus()
			else:
				get_action_child().handle_action(gui_steering.gui_actions.right)

		gui_steering.gui_actions.press:
			get_action_child().handle_action(gui_steering.gui_actions.press)

func _on_focus_entered(): 
	get_action_child().handle_on_focus_entered()
	$FocusSound.play()

	_create_delay()

func _create_delay() -> void:
	should_handle_input = false
	yield(get_tree().create_timer(0.15), "timeout")
	should_handle_input = true

func _on_focus_exited():
	get_action_child().handle_on_focus_exited()


func set_audio_volume(value: float) -> void:
	$FocusSound.set_volume_db(linear2db(value))
	$ActionSound.set_volume_db(linear2db(value))


func get_action_child():
	return get_child(get_child_count()-1)
