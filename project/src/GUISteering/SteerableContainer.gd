extends PanelContainer

class_name SteerableContainer

var focus_entered_theme : Theme = load("res://assets/FocusedPanel.tres")
var focus_exited_theme : Theme = load("res://assets/Panel.tres")

var focus_entered_stylebox_color_begin : Color = focus_entered_theme.get_stylebox("panel", "PanelContainer").get_border_color()
var focus_entered_stylebox_color_end : Color = Color.white
var invert_stylebox_colors : bool = true

var should_handle_input : bool = true

var gui_steering = GUISteering.new()

func _ready():
	set_theme(focus_exited_theme)

	connect("focus_entered", self, "_on_focus_entered")
	connect("focus_exited", self, "_on_focus_exited")

	get_action_child().connect("mouse_entered", self, "grab_focus")

	Settings.connect("audio_effects_volume_changed", self, "set_audio_volume")
	set_audio_volume(Settings.audio_effects_volume)

	$Tween.interpolate_property(focus_entered_theme.get_stylebox("panel", "PanelContainer"), "border_color", null, Color.white, 0.5, Tween.TRANS_LINEAR)
	$Tween.connect("tween_all_completed", self, "_on_tween_completed")


func _on_tween_completed() -> void:
	if invert_stylebox_colors:
		$Tween.interpolate_property(focus_entered_theme.get_stylebox("panel", "PanelContainer"), "border_color", focus_entered_stylebox_color_end, focus_entered_stylebox_color_begin, 0.5, Tween.TRANS_LINEAR)
	else:
		$Tween.interpolate_property(focus_entered_theme.get_stylebox("panel", "PanelContainer"), "border_color", focus_entered_stylebox_color_begin, focus_entered_stylebox_color_end, 0.5, Tween.TRANS_LINEAR)
	$Tween.start()
	invert_stylebox_colors = not invert_stylebox_colors


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
	set_theme(focus_entered_theme)
	$Tween.start()
	$FocusSound.play()

	_create_delay()

func _create_delay() -> void:
	should_handle_input = false
	yield(get_tree().create_timer(0.15), "timeout")
	should_handle_input = true

func _on_focus_exited():
	set_theme(focus_exited_theme)
	$Tween.stop($Tween)


func set_audio_volume(value: float) -> void:
	$FocusSound.set_volume_db(linear2db(value))
	$ActionSound.set_volume_db(linear2db(value))


func get_action_child():
	return get_child(get_child_count()-1)
