extends Particles2D

class_name ShotParticle

func init(position, show_behind_parent):
	self.position = position
	self.show_behind_parent = show_behind_parent

func _ready():
	emitting = true
	yield(get_tree().create_timer(3), "timeout")
	queue_free()
