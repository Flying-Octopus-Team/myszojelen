extends FocusableContainer

func _ready():
	$HBoxContainer/UnpauseHBox/UnpauseBtnRect/UnpauseBtn.connect("pressed", self, "hide_screen")
	$HBoxContainer/RetryHBox/RetryBtnRect/RetryBtn.connect("pressed", self, "_replay_level")
	$HBoxContainer/SettingsHBox/SettingsBtnRect/SettingsBtn.connect("pressed", self, "_show_settings_screen")
	$HBoxContainer/ReturnHBox/ReturnBtnRect/ReturnBtn.connect("pressed", self, "_return_to_menu")

func hide_screen() -> void:
	.hide()
	get_tree().paused = false
	$"../../".hide()


func show():
	.show()
	
	get_tree().paused = true
	$"../../".show()


func _show_settings_screen() -> void:
	hide()
	$"../SettingsScreen".show()


func _replay_level() -> void:
	get_tree().reload_current_scene()

	get_tree().paused = false

func _return_to_menu() -> void:
	get_tree().change_scene("res://src/MainMenu/MainMenu.tscn")

	get_tree().paused = false


func _process(delta):
	if gui_steering.is_pause_pressed() and should_handle_input:
		$"../SettingsScreen".hide()
		hide_screen()
		
		should_handle_input = false
		yield(get_tree().create_timer(0.15), "timeout")
		should_handle_input = true
