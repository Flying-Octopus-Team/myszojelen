extends FocusableContainer

onready var animation_player = $AnimationPlayer


func show() -> void:
	.show()
	animation_player.play("show_panel")
	set_process_unhandled_input(true)


func hide() -> void:
	animation_player.play_backwards("show_panel")
	set_process_unhandled_input(false)
	
	yield(animation_player, "animation_finished")
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
	OS.shell_open("https://flyingoctopus.pl/")


func _on_XBtn_pressed():
	hide()


func _on_CC_3_LinkBtn_pressed():
	OS.shell_open("https://creativecommons.org/licenses/by-nc/4.0/")


func _on_glassocean_btn_pressed():
	OS.shell_open("https://opengameart.org/users/hectavex")


func _on_rasmus_btn_pressed():
	OS.shell_open("https://opengameart.org/users/spring")


func _on_SonicIdols_LinkBtn_pressed():
	OS.shell_open("https://sonicidols.com")
