extends AudioStreamPlayer

export var loop := false setget set_loop
export var time_between_loops := 5.0

onready var replay_timer = $ReplayTimer

var _force_stopped := false


func _ready() -> void:
	connect("finished", self, "_on_finished")


func play(from_position:float = 0.0) -> void:
	_force_stopped = false
	.play(from_position)


# Use this method to stop music and be sure, it will not be replayed
func force_stop() -> void:
	stop()
	_force_stopped = true
	replay_timer.stop()


func set_loop(v:bool) -> void:
	loop = v


func _on_ReplayTimer_timeout() -> void:
	play()


func _on_finished():
	if loop and not _force_stopped:
		replay_timer.start(time_between_loops)

