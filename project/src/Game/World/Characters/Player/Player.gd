extends Character

var RiceBullet = preload("res://src/Game/World/Characters/RiceBullet/RiceBullet.tscn")

onready var shot_particles : Particles2D = $Pivot/Sprite/ShotParticles
onready var shot_particles_default_x = shot_particles.position.x

var shot_particles_position : Dictionary = {
	Facing.TOP_LEFT: Vector2(-130, -60),
	Facing.TOP_RIGHT: Vector2(130, -60),
	Facing.BOTTOM_LEFT: Vector2(-130, -20),
	Facing.BOTTOM_RIGHT: Vector2(130, -20)
}

onready var shot_sound = $ShotSound

var direction = {
	"UP": Vector2(0, -1),
	"DOWN": Vector2(0, 1),
	"LEFT": Vector2(-1, 0),
	"RIGHT": Vector2(1, 0)
}


func _process(delta) -> void:
	if Input.is_action_pressed("ui_up"):
		get_tree().set_input_as_handled()
		move(direction["UP"])
		_rotate_to(Facing.TOP_RIGHT)
	
	elif Input.is_action_pressed("ui_down"):
		get_tree().set_input_as_handled()
		move(direction["DOWN"])
		_rotate_to(Facing.BOTTOM_LEFT)
	
	elif Input.is_action_pressed("ui_left"):
		get_tree().set_input_as_handled()
		move(direction["LEFT"])
		_rotate_to(Facing.TOP_LEFT)
	
	elif Input.is_action_pressed("ui_right"):
		get_tree().set_input_as_handled()
		move(direction["RIGHT"])
		_rotate_to(Facing.BOTTOM_RIGHT)


func _unhandled_key_input(event):
	if Input.is_action_just_released("shot"):
		_shot()
	
#	if Input.is_action_just_pressed("ui_left"):
#		_rotate(-1)
#		get_tree().set_input_as_handled()
#
#	elif Input.is_action_just_pressed("ui_right"):
#		_rotate(1)
#		get_tree().set_input_as_handled()
#


func _unhandled_input(event) -> void:
	if not event is InputEventMouseButton:
		return
	
	if event.button_index != BUTTON_LEFT:
		print(tile_map.get_cellv(tile_map.world_to_map(get_global_mouse_position())))


func _shot() -> void:
	var rice = RiceBullet.instance()
	rice.facing = facing
	world_objects.add_child(rice)
	rice.position = position + tile_map.map_to_world(get_forward_dir())
	rice.tile_map = tile_map
	shot_particles.emitting = true
	shot_sound.play()


func move(dir:Vector2) -> void:
	var target_pos = tile_map.request_move(self, dir)
	
	if target_pos != null:
		move_to(target_pos)


func move_to(target_pos:Vector2) -> void:
	set_process(false)
	.move_to(target_pos)
	yield(self, "move_end")
	set_process(true)


func update_texture() -> void:
	.update_texture()
	
	shot_particles.position = shot_particles_position[facing]
	shot_particles.show_behind_parent = facing == Facing.TOP_LEFT or facing == Facing.TOP_RIGHT
