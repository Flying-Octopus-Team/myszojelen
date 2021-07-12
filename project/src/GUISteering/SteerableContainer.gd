extends TextureRect

class_name SteerableContainer

export var focus_texture : Texture

var is_first_input : bool = true
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
	
	if is_first_input:
		is_first_input = false
		return

	if event is InputEventMouseMotion and not has_focus():
		grab_focus()

	match gui_steering.get_action(event):
		gui_steering.gui_actions.down:
			get_node(get_focus_neighbour(MARGIN_BOTTOM)).grab_focus()

		gui_steering.gui_actions.up:
			get_node(get_focus_neighbour(MARGIN_TOP)).grab_focus()

func _on_focus_entered(): 
	set_texture(focus_texture)
	$FocusSound.play()

	if SteeringSave.steering_type == "Pad" or SteeringSave.steering_type == "VirtualPad":
		should_handle_input = false
		yield(get_tree().create_timer(0.2), "timeout")
		should_handle_input = true

func _on_focus_exited():
	set_texture(null)
	is_first_input = true

func set_audio_volume(value: float) -> void:
	$FocusSound.set_volume_db(linear2db(value))
	$ActionSound.set_volume_db(linear2db(value))
	
