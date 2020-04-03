extends CanvasLayer

signal faded_in
signal faded_out

onready var color_rect = $ColorRect
onready var tween = $Tween


func fade_in(color:Color, fade_time:float=1.0) -> void:
	var transparent_color = color
	transparent_color.a = 0
	
	color_rect.show()
	
	tween.interpolate_property(color_rect, "color", color, transparent_color, fade_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	color_rect.hide()
	
	emit_signal("faded_in")


func fade_out(color:Color, fade_time:float=1.0) -> void:
	var transparent_color = color
	transparent_color.a = 0
	
	color_rect.show()
	
	tween.interpolate_property(color_rect, "color", transparent_color, color, fade_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	emit_signal("faded_out")
