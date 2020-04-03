extends Enemy

export var time_to_next_move := 0.5


func _ready() -> void:
	randomize()
	prepare_time_to_next_move()
	next_move_timer.start()


func _on_NextMoveTimer_timeout():
	._on_NextMoveTimer_timeout()
	prepare_time_to_next_move()


func prepare_time_to_next_move() -> void:
	next_move_timer.wait_time = time_to_next_move + rand_range(-0.2, 0.2)
