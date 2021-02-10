extends TextureButton

export var upscale_on_hover : bool = false
export var upscale_on_press : bool = false
export var steering_name : String =  ""
var is_pressed : bool = false

func _ready() -> void:
	rect_pivot_offset = rect_size * 0.5
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	connect("button_down", self, "_on_button_down")
	connect("pressed", get_parent().get_parent().get_parent().get_parent(), "change_steering", [steering_name])


func _on_mouse_entered() -> void:
	if upscale_on_hover:
		upscale()


func _on_mouse_exited() -> void:
	if (upscale_on_hover and !is_pressed):
		_reset_scale()

func upscale() -> void:
	if not disabled and upscale_on_press:
		rect_scale = Vector2(1.05, 1.05)
		is_pressed = true

func _reset_scale() -> void:
	rect_scale = Vector2.ONE


func set_disabled(dis:bool) -> void:
	disabled = dis
	
	if dis:
		_reset_scale()
		
func downscale() -> void:
	is_pressed = false
	_on_mouse_exited()
