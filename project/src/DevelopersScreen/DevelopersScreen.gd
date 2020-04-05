extends Control

onready var animatio_player = $AnimationPlayer


func show() -> void:
	.show()
	animatio_player.play("show_panel")
	set_process_unhandled_input(true)


func hide() -> void:
	animatio_player.play_backwards("show_panel")
	set_process_unhandled_input(false)
	
	yield(animatio_player, "animation_finished")
	.hide()


func _unhandled_input(event) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		hide()
		get_tree().set_input_as_handled()


func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton:
		hide()
		get_tree().set_input_as_handled()


func _on_LinkButton_pressed():
	OS.shell_open("http://elf-vs-dwarves.pl/")
