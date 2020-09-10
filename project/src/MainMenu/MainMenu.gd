extends Control

export var intro_story_scene : PackedScene
export var game_scene : PackedScene

export var fade_color : Color = Color.black
export var fade_time : float = 1.0

onready var train_animation := $Background/Train/TrainAnimation
onready var music_player := $MusicPlayer
onready var fade_layer := $FadeLayer


func _ready() -> void:
	OS.window_maximized = true
	
	find_node("NewGameBtn").connect("pressed", self, "_new_game")
	find_node("ContinueBtn").connect("pressed", self, "_continue_game")
	find_node("SettingsBtn").connect("pressed", self, "_open_settings")
	find_node("ExitBtn").connect("pressed", self, "_exit_game")
	
	train_animation.play("TrainIn")
	
	music_player.call_deferred("play")


func _new_game() -> void:
	_disable_all_buttons()
	
	fade_layer.fade_out(fade_color, fade_time)
	music_player.fade_out()
	
	yield(fade_layer, "faded_out")
	
	get_tree().change_scene_to(intro_story_scene)


func _continue_game() -> void:
	_disable_all_buttons()
	
	fade_layer.fade_out(fade_color, fade_time)
	music_player.fade_out()
	
	yield(fade_layer, "faded_out")
	
	get_tree().change_scene_to(game_scene)


func _open_settings() -> void:
	print("Opening settings...")


func _disable_all_buttons() -> void:
	for button in find_node("ButtonsContainer").get_children():
		button.disabled = true


func _exit_game() -> void:
	get_tree().quit()
