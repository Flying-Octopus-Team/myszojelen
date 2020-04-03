extends Character


func _process(delta) -> void:
	if Input.is_action_pressed("ui_up"):
		get_tree().set_input_as_handled()
		move(get_forward_dir())


func _unhandled_key_input(event):
	if Input.is_action_just_pressed("ui_left"):
		get_tree().set_input_as_handled()
		_rotate(-1)
	
	elif Input.is_action_just_pressed("ui_right"):
		get_tree().set_input_as_handled()
		_rotate(1)


func _unhandled_input(event) -> void:
	if not event is InputEventMouseButton:
		return
	
	if event.button_index != BUTTON_LEFT:
		print(tile_map.get_cellv(tile_map.world_to_map(get_global_mouse_position())))


func move(dir:Vector2) -> void:
	var target_pos = tile_map.request_move(self, dir)
	
	if target_pos != null:
		move_to(target_pos)


func move_to(target_pos:Vector2) -> void:
	set_process(false)
	.move_to(target_pos)
	yield(self, "move_end")
	set_process(true)
