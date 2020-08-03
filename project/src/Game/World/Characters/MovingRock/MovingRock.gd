extends Character

func try_to_move(direction : Vector2):
	var current_map_pos = tile_map.world_to_map(position)
	var target_pos = current_map_pos + direction
	var target_object = tile_map.get_world_object_from_map_pos(target_pos)
	var current_anim = animation_player.current_animation
	
	if target_object == null && current_anim == "":
		var world_target_pos = tile_map.map_to_world(target_pos)
		move_to(world_target_pos)
