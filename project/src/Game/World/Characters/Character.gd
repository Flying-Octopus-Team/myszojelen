extends WorldObject
class_name Character

signal move_start
signal move_middle
signal move_end

var tile_map : TileMap
var navigation : Navigation2D

export var top_right_texture : Texture
export var bottom_right_texture : Texture

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
onready var pivot_move_tween = $PivotMoveTween
onready var animation_player = $AnimationPlayer

var facing : int = Facing.BOTTOM_RIGHT

var move_animation_name := "hop"


func _ready() -> void:
	update_texture()


func move_to(target_pos:Vector2) -> void:
	emit_signal("move_start")
	
	animation_player.play(move_animation_name)
	
	var diff_pos = target_pos - position
	position = target_pos
	
	pivot.position = -diff_pos
	pivot_move_tween.interpolate_property(pivot, "position", null, Vector2.ZERO, animation_player.current_animation_length)
	
	pivot_move_tween.start()
	
	yield(pivot_move_tween, "tween_all_completed")
	
	pivot.position = Vector2.ZERO
	sprite.position = Vector2.ZERO
	
	emit_signal("move_end")


func _rotate(dir:int) -> void:
	_rotate_to((facing + dir + 4) % 4)


func _rotate_to(to:int) -> void:
	animation_player.play(move_animation_name)
	facing = to
	
	yield(self, "move_middle")
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
