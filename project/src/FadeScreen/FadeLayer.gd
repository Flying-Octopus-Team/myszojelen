extends CanvasLayer

signal faded_in
signal faded_out

onready var color_rect = $ColorRect
onready var tween = $Tween

var fading_in : bool


func _ready() -> void:
	tween.connect("tween_all_completed", self, "_on_tween_all_completed")


func _on_tween_all_completed() -> void:
	if fading_in:
		color_rect.hide()
		emit_signal("faded_in")
	else:
		emit_signal("faded_out")


func fade_in(color:Color, fade_time:float=1.0) -> void:
	_fade(color, fade_time, true)


func fade_out(color:Color, fade_time:float=1.0) -> void:
	_fade(color, fade_time, false)


func _fade(color:Color, fade_time:float, _in:bool) -> void:
	if tween.is_active():
		tween.stop_all()
	
	var transparent_color = color
	transparent_color.a = 0
	
	var target_color : Color
	
	if _in:
		color_rect.color = color
		target_color = transparent_color
	else:
		color_rect.color = transparent_color
		target_color = color
	
	color_rect.show()
	
	tween.interpolate_property(color_rect, "color", null, target_color, fade_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	fading_in = _in
