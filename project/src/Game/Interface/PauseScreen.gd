extends FocusableContainer

func hide_screen() -> void:
	.hide()
	get_tree().paused = false
	$"../../".hide()


func show():
	.show()
	
	get_tree().paused = true
	$"../../".show()
