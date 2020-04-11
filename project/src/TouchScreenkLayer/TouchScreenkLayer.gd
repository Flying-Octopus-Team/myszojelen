extends CanvasLayer

export var hide_on_non_touchscreen := true

onready var container = $Container
onready var joy = $Container/JoyStick/Joy

onready var visible := true setget set_visible


func _ready() -> void:
	if hide_on_non_touchscreen:
		set_visible(OS.has_touchscreen_ui_hint())


func set_visible(v:bool) -> void:
	visible = v
	container.visible = v


func get_joy_vec() -> Vector2:
	return joy.get_vec()


func get_joy_angle() -> float:
	return joy.get_angle()
