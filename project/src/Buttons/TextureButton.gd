extends TextureButton

const CHILD_MOVE_VECTOR : Vector2 = Vector2(10, 10)

onready var default_texture : Texture = get_normal_texture()

func _ready() -> void:
	rect_pivot_offset = rect_size * 0.5

	connect("button_down", self, "_on_button_down")
	connect("button_up", self, "_on_button_up")

	get_parent().connect("focus_entered", self, "on_focus_entered")
	get_parent().connect("focus_exited", self, "on_focus_exited")

	get_child(0).connect("mouse_entered", get_parent(), "grab_focus")

func _on_button_down() -> void:
	get_child(0).rect_position += CHILD_MOVE_VECTOR


func _on_button_up() -> void:
	get_child(0).rect_position -= CHILD_MOVE_VECTOR


func handle_action(action: int) -> void:
	if action == GUISteering.gui_actions.left or action == GUISteering.gui_actions.right:
		return
	
	_set_button_pressed()
	get_parent().create_delay(1.1)


func _set_button_pressed() -> void:
	emit_signal("pressed")

	_on_button_down()
	set_normal_texture(get_pressed_texture())

	yield(get_tree().create_timer(0.5), "timeout")

	_on_button_up()
	set_normal_texture(default_texture)


func on_focus_entered() -> void:
	set_normal_texture(get_hover_texture())

func on_focus_exited() -> void:
	set_normal_texture(default_texture)
