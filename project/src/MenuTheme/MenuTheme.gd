extends AudioStreamPlayer

export var loop := false setget set_loop

onready var replay_timer = $ReplayTimer

var replay := true


func set_loop(v:bool) -> void:
	loop = v
	
	if replay:
		play()


func _on_ReplayTimer_timeout() -> void:
	if replay:
		play()


func _on_MenuTheme_finished():
	if replay and loop:
		replay_timer.start()
