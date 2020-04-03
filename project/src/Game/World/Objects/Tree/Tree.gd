extends WorldObject

signal cutted

export var life : int = 5
export(Array, Texture) var textures : Array
export var trunk_texture : Texture


func _ready() -> void:
	randomize()
	var random_idx = randi() % textures.size()
	var random_texture = textures[random_idx]
	$Sprite.texture = random_texture


func cut(speed:int) -> bool:
	if life <= 0:
		return false
	
	life -= speed
	
	if life <= 0: # Died
		stop_cutting()
		$CuttedParticles.emitting = true
		$Sprite.texture = trunk_texture
		
		emit_signal("cutted")
		
		return false
	
	if not $SticksParticles.emitting:
		start_cutting()
	
	return true


func start_cutting() -> void:
	$SticksParticles.emitting = true
	$SmokeParticles.emitting = true


func stop_cutting() -> void:
	$SticksParticles.emitting = false
	$SmokeParticles.emitting = false


func _on_Tween_tween_all_completed():
	$Sprite.hide()
	queue_free()
