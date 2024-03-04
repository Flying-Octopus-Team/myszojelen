extends CanvasLayer

export var hide_on_non_touchscreen := true

onready var container = $Container
onready var joy = $Container/JoyStick/Joy

onready var visiblee := true setget set_visible


func _ready() -> void:
	if hide_on_non_touchscreen:
		set_visible(OS.has_touchscreen_ui_hint())

	$Container/ShotButton.connect("pressed", self, "shoot")


func set_visible(v:bool) -> void:
	visiblee = v
	container.visible = v


func get_joy_vec() -> Vector2:
	return joy.get_vec()


func get_joy_angle() -> float:
	return joy.get_angle()


func shoot() -> void:
	get_parent()._shot()
