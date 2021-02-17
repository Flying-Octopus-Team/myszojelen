extends Character

var RiceBullet = preload("res://src/Game/World/Characters/RiceBullet/RiceBullet.tscn")

onready var shot_particles : Particles2D = $Pivot/Sprite/ShotParticles
onready var shot_particles_default_x = shot_particles.position.x

var shot_particles_position : Dictionary = {
	Facing.TOP_LEFT: Vector2(-130, -60),
	Facing.TOP_RIGHT: Vector2(130, -60),
	Facing.BOTTOM_LEFT: Vector2(-130, -20),
	Facing.BOTTOM_RIGHT: Vector2(130, -20),
	Facing.TOP: Vector2(0, -60),
	Facing.BOTTOM: Vector2(0, -20),
	Facing.LEFT: Vector2(-130, 0),
	Facing.RIGHT: Vector2(130, 0)
}

onready var shot_sound = $ShotSound

const HALF_PI = PI / 2.0

export var joy_sensinitivy := 0.5 

export var wait_time_after_rotate := 0.2 
onready var _time_after_rotate := wait_time_after_rotate

onready var steering : Node = $Steering


func _process(delta) -> void:
	steering.steer(delta)


func _unhandled_input(event) -> void:
	if not event is InputEventMouseButton:
		_process_key_input()
		return
	
	if event.button_index != BUTTON_LEFT:
		print(tile_map.get_cellv(tile_map.world_to_map(get_global_mouse_position())))


func _process_key_input() -> void:
	if Input.is_action_just_pressed("shot"):
		_shot()


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


func _rotate(dir:int) -> void:
	set_process(false)
	._rotate(dir)
	yield(animation_player, "animation_finished")
	set_process(true)


func update_texture() -> void:
	.update_texture()
	
	shot_particles.position = shot_particles_position[facing]
	shot_particles.show_behind_parent = facing == Facing.TOP_LEFT or facing == Facing.TOP_RIGHT
