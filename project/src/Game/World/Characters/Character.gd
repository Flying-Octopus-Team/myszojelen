extends WorldObject
class_name Character

signal move_start
signal move_middle
signal move_end

var tile_map : TileMap
var world_objects : Node2D

export var top_right_texture : Texture
export var bottom_right_texture : Texture
export var right_texture : Texture
export var top_texture: Texture
export var bottom_texture: Texture

export var move_speed : float = 1

enum Facing {
	TOP_LEFT, 
	TOP_RIGHT,
	BOTTOM_RIGHT,
	BOTTOM_LEFT,
	TOP,
	BOTTOM,
	LEFT,
	RIGHT
}

#TODO add textures for directions: top bottom
onready var textures : Dictionary = {
	Facing.TOP_LEFT: top_right_texture,
	Facing.TOP_RIGHT: top_right_texture,
	Facing.BOTTOM_RIGHT: bottom_right_texture,
	Facing.BOTTOM_LEFT: bottom_right_texture,
	Facing.TOP: top_texture,
	Facing.BOTTOM: bottom_texture,
	Facing.RIGHT: right_texture,
	Facing.LEFT: right_texture
}

onready var sprite = $Pivot/Sprite
onready var pivot = $Pivot
onready var pivot_move_tween = $PivotMoveTween
onready var animation_player : AnimationPlayer = $AnimationPlayer

var facing : int = Facing.BOTTOM_RIGHT

var move_animation_name := "hop"

var previous_position = null


func _ready() -> void:
	pivot_move_tween.connect("tween_completed", self, "_on_move_end")
	call_deferred("update_texture")


func setup_map() -> void:
	tile_map.set_cellv(tile_map.world_to_map(position), type)
	tile_map.obstacles.append(tile_map.world_to_map(position))


func move_to(target_pos:Vector2) -> void:
	emit_signal("move_start")
	
	tile_map.set_cellv(tile_map.world_to_map(target_pos), type)
	
	animation_player.play(move_animation_name)
	
	previous_position = position
	var diff_pos = target_pos - position
	position = target_pos
	
	pivot.position = -diff_pos
	pivot_move_tween.interpolate_property(pivot, "position", null, Vector2.ZERO, animation_player.current_animation_length / move_speed)

	pivot_move_tween.start()
	
	var character_world_object = tile_map.get_world_object_from_map_pos(tile_map.world_to_map(previous_position))
	if character_world_object:
		character_world_object.position = position

	var previous_position_map = tile_map.world_to_map(previous_position)
	var position_map = tile_map.world_to_map(position)

	tile_map.astar_node.update_walkable_point(position_map)
	tile_map.astar_node.remove_point(tile_map.astar_node.calculate_point_index(position_map))

	tile_map.astar_node.add_point(tile_map.astar_node.calculate_point_index(previous_position_map), Vector3(previous_position_map.x, previous_position_map.y, 0.0))
	tile_map.astar_node.update_walkable_point(previous_position_map)

func _on_move_end(object: Object, key: NodePath) -> void:
	if previous_position:
		tile_map.set_cellv(tile_map.world_to_map(previous_position), tile_map.EMPTY_TILE)
		previous_position = null
	
	pivot.position = Vector2.ZERO
	
	emit_signal("move_end")


func _rotate(dir:int) -> void:
	_rotate_to((facing + dir + 4) % 4)


func _rotate_to(to:int) -> void:
	animation_player.play(move_animation_name)
	facing = to
	
	update_texture()


#TODO add condition to flip_h when 8 directions textures are added
func update_texture() -> void:
	sprite.texture = textures[facing]
	sprite.flip_h = (facing == Facing.TOP_LEFT or facing == Facing.BOTTOM_LEFT or facing == Facing.LEFT)


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
		Facing.TOP:
			dir.x = -1
			dir.y = -1
		Facing.BOTTOM:
			dir.x = 1
			dir.y = 1
		Facing.LEFT:
			dir.x = -1
			dir.y = 1
		Facing.RIGHT:
			dir.x = 1
			dir.y = -1
	
	return dir
