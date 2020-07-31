extends Character


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func try_to_move(direction : Vector2):
	var current_map_pos = tile_map.world_to_map(position)
	var target_pos = current_map_pos + direction
	var world_target_pos = tile_map.map_to_world(target_pos)
	move_to(world_target_pos)
	
