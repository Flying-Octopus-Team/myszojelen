extends Enemy

export var time_to_next_move := 0.5

onready var cutting_animation : Dictionary

onready var cutting_animation_player : AnimationPlayer = $CuttingAnimationPlayer


func _ready() -> void:
	randomize()
	prepare_time_to_next_move()
	next_move_timer.start()
	
	cutting_animation = {
	Facing.TOP_LEFT: "cut_up",
	Facing.TOP_RIGHT: "cut_up",
	Facing.BOTTOM_RIGHT: "cut_down",
	Facing.BOTTOM_LEFT: "cut_down"
} 


func _on_state_changed(previous_state:int) -> void:
	match state:
		State.IDLE:
			pass
		State.WALK:
			if previous_state == State.CUTTING:
				cutting_animation_player.stop()
		State.CUTTING:
			update_texture()


func _on_NextMoveTimer_timeout():
	._on_NextMoveTimer_timeout()
	prepare_time_to_next_move()


func prepare_time_to_next_move() -> void:
	next_move_timer.wait_time = time_to_next_move + rand_range(-0.2, 0.2)


func update_texture() -> void:
	sprite.flip_h = (facing == Facing.TOP_LEFT or facing == Facing.BOTTOM_LEFT)
	
	if state == State.CUTTING:
		cutting_animation_player.play(cutting_animation[facing])
	else:
		sprite.texture = textures[facing]


func _die() -> void:
	animation_player.play("hop")
	
	if state == State.CUTTING:
		set_state(State.IDLE)
		cutted_tree.stop_cutting()
	
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()
