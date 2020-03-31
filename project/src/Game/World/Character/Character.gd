extends Node2D
class_name Character

var tile_map : TileMap

var pos_on_tile_map : Vector2

export var top_right_texture : Texture
export var bottom_right_texture : Texture

export var body_move_time : float

enum Facing {
	TOP_LEFT, 
	TOP_RIGHT,
	BOTTOM_RIGHT,
	BOTTOM_LEFT
}

onready var textures : Dictionary = {
	Facing.TOP_LEFT: top_right_texture,
	Facing.TOP_RIGHT: top_right_texture,
	Facing.BOTTOM_RIGHT: bottom_right_texture,
	Facing.BOTTOM_LEFT: bottom_right_texture
}

onready var sprite = $Pivot/Sprite
onready var pivot = $Pivot
onready var body_move_tween = $BodyMoveTween

var facing : int = Facing.BOTTOM_RIGHT

const EMPTY_TILE := -1


func _ready() -> void:
	yield(get_parent().get_parent(), "ready")
	pos_on_tile_map = tile_map.world_to_map(global_position)
	update_texture()


func move(direction:Vector2) -> void:
	var target_tile_pos := pos_on_tile_map + direction
	var target_tile = tile_map.get_cell(
		int(target_tile_pos.x), 
		int(target_tile_pos.y)
	)
	
	if target_tile == EMPTY_TILE:
		var target_pos = tile_map.map_to_world(target_tile_pos)
		var temp_pos = position
		position = target_pos
		pos_on_tile_map += direction
		
		body_move_tween.interpolate_property(pivot, "global_position", temp_pos, target_pos, body_move_time)
		
		body_move_tween.interpolate_property(sprite, "position", Vector2.ZERO, Vector2(0, -8), body_move_time * 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
		body_move_tween.start()
		
		body_move_tween.interpolate_property(sprite, "position", Vector2(0, -8), Vector2.ZERO, body_move_time * 0.5, Tween.TRANS_BACK, Tween.EASE_IN, body_move_time * 0.5)
		
		yield(body_move_tween, "tween_all_completed")
		
		pivot.position = Vector2.ZERO
		sprite.position = Vector2.ZERO


func _rotate(dir:int) -> void:
	facing = (facing + dir + 4) % 4
	update_texture()


func update_texture() -> void:
	sprite.texture = textures[facing]
	sprite.flip_h = (facing == Facing.TOP_LEFT or facing == Facing.BOTTOM_LEFT)


func get_forward_dir() -> Vector2:
	var dir := Vector2.ZERO
	match facing:
		Facing.TOP_LEFT:
			dir.x = -1
		Facing.TOP_RIGHT:
			dir.y = -1
		Facing.BOTTOM_RIGHT:
			dir.x = 1
		Facing.BOTTOM_LEFT:
			dir.y = 1
	
	return dir
