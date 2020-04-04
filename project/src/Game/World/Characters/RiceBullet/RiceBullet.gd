extends Character

export var move_range : int

var is_alive := true


func _ready() -> void:
	move_animation_name = "rice_move"
	var all_fly_length = animation_player.get_animation(move_animation_name).length * move_range
	$RiceFallTween.interpolate_property(sprite, "offset", null, Vector2(0, 120), all_fly_length, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$RiceFallTween.interpolate_property(sprite, "scale", null, Vector2(0.3, 0.3), all_fly_length, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$RiceFallTween.start()


func _process(delta) -> void:
	_check_if_hitted_something()
	
	if not is_alive:
		set_process(false)
		return
	
	var dir = get_forward_dir()
	var map_pos = tile_map.world_to_map(position)
	var target_map_pos = map_pos + dir
	
	var target_pos = tile_map.map_to_world(target_map_pos)
	set_process(false)
	.move_to(target_pos)
	
	yield(self, "move_end")
	
	move_range -= 1
	if move_range <= 0:
		_check_if_hitted_something()
		destroy()
	else:
		set_process(true)


func _check_if_hitted_something() -> void:
	var map_pos = tile_map.world_to_map(position)
	var target_object = tile_map.get_world_object_from_map_pos(map_pos)
	
	if target_object != null and target_object.type != Type.PLAYER:
		if target_object.type == Type.ENEMY:
			var enemy = tile_map.get_world_object_from_map_pos(map_pos)
			enemy.hit()
		
		destroy()


func destroy() -> void:
	set_process(false)
	is_alive = false
	$Pivot/Shadow.hide()
	sprite.hide()
	$Pivot/DestroyParticles.emitting = true
