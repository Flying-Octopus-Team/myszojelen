extends Character

export var move_range : int
export var move_time : float

var is_alive := true

func _ready() -> void:
	move_animation_name = "rice_move"
	var all_fly_length = move_time * move_range
	$RiceFallTween.interpolate_property(sprite, "offset", null, Vector2(0, 120), all_fly_length, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$RiceFallTween.interpolate_property(sprite, "scale", null, Vector2(0.3, 0.3), all_fly_length, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$RiceFallTween.start()


func _process(delta) -> void:
	if _hit_something():
		destroy()
	
	if not is_alive:
		set_process(false)
		return
	
	var dir = get_forward_dir()
	var map_pos = tile_map.world_to_map(position)
	var target_map_pos = map_pos + dir
	
	var target_pos = tile_map.map_to_world(target_map_pos)
	set_process(false)
	
	var diff_pos = target_pos - position
	position = target_pos
	
	pivot.position = -diff_pos
	pivot_move_tween.interpolate_property(pivot, "position", null, Vector2.ZERO, move_time)
	
	pivot_move_tween.start()
	
	yield(pivot_move_tween, "tween_completed")
	
	pivot.position = Vector2.ZERO
	sprite.position = Vector2.ZERO
	
	move_range -= 1
	if move_range <= 0:
		_hit_something()
		destroy()
	else:
		set_process(true)


func _hit_something() -> bool:
	var map_pos = tile_map.world_to_map(position)
	var target_object = tile_map.get_world_object_from_map_pos(map_pos)
	
	if target_object != null and target_object.type != Type.PLAYER:
		if target_object.type == Type.ENEMY:
			target_object.hit()
		if target_object.type == Type.OBSTACLE:
			target_object.try_to_move(get_forward_dir())
		return true

	return false


func destroy() -> void:
	set_process(false)
	is_alive = false
	$Pivot/Shadow.hide()
	sprite.hide()
	$Pivot/DestroyParticles.emitting = true
