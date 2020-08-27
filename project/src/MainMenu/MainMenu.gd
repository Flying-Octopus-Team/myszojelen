extends Control

export var intro_story_scene : PackedScene
export var game_scene : PackedScene


func _ready() -> void:
	OS.window_maximized = true
	
	find_node("NewGameBtn").connect("pressed", self, "_new_game")
	find_node("ContinueBtn").connect("pressed", self, "_continue_game")
	find_node("SettingsBtn").connect("pressed", self, "_open_settings")
	find_node("ExitBtn").connect("pressed", self, "_exit_game")


func _new_game() -> void:
	get_tree().change_scene_to(intro_story_scene)


func _continue_game() -> void:
	get_tree().change_scene_to(game_scene)


func _open_settings() -> void:
	print("Opening settings...")


func _exit_game() -> void:
	get_tree().quit()
