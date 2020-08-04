extends WorldObject

signal cutted

export var life : float = 5.0
export(Array, Texture) var textures : Array
export var trunk_texture : Texture


func _ready() -> void:
	randomize()
	var random_idx = randi() % textures.size()
	var random_texture = textures[random_idx]
	$Sprite.texture = random_texture


func cut(cut_speed_modifier: float) -> bool:
	if life <= 0:
		return false
	
	life -= 1 * cut_speed_modifier
	
	if life <= 0: # Died
		die()
		return false
	
	if not $SticksParticles.emitting:
		start_cutting()
	
	return true


func die() -> void:
	stop_cutting()
	$CuttedParticles.emitting = true
	$Sprite.texture = trunk_texture
	
	type = Type.EMPTY
	
	emit_signal("cutted")


func start_cutting() -> void:
	$SticksParticles.emitting = true
	$SmokeParticles.emitting = true


func stop_cutting() -> void:
	$SticksParticles.emitting = false
	$SmokeParticles.emitting = false


func _on_Tween_tween_all_completed():
	$Sprite.hide()
	queue_free()
