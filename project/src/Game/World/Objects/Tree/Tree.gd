extends WorldObject

export var life : int = 5
export(Array, Texture) var textures_array : Array

onready var tween : Tween = $Tween


func _ready() -> void:
	randomize()
	var random_idx = randi() % textures_array.size()
	var random_texture = textures_array[random_idx]
	$Sprite.texture = random_texture


func cut() -> bool:
	life -= 1
	
	if life <= 0: # Died
		stop_cutting()
		$CuttedParticles.emitting = true
		
		tween.interpolate_property($Sprite, "modulate", null, Color(1, 1, 1, 0), 0.3)
		tween.start()
		
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
