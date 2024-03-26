extends Control

export var intro_story_scene : PackedScene
export var game_scene : PackedScene

export var fade_color : Color = Color.black
export var fade_time : float = 1.0

onready var train_animation := $Background/Train/TrainAnimation
onready var fade_layer := $FadeLayer

onready var main = find_node("MainButtons")
onready var settings = find_node("SettingsScreen")
onready var credits = find_node("DevelopersScreen")

onready var screens_dict := {
	"main": main,
	"settings": settings,
	"credits": credits
}


func _ready() -> void:
	OS.window_maximized = true
	
	find_node("NewGameBtn").connect("pressed", self, "_new_game")
	find_node("ContinueBtn").connect("pressed", self, "_continue_game")
	find_node("ExitBtn").connect("pressed", self, "_exit_game")
	
	# Settings navigation buttons
	find_node("SettingsBtn").connect("pressed", self, "_show_screen", [settings])
	find_node("BackBtn").connect("pressed", self, "_show_screen", [main])
	
	#Credits navigation buttons
	find_node("XBtn").connect("pressed", self, "_show_screen", [main])
	find_node("ColorRect").connect("gui_input", self, "_on_ColorRect_gui_input")
	find_node("CreditsBtn").connect("pressed", self, "_show_screen", [credits])
	
	_show_screen(main)
	
	train_animation.play("TrainIn")
	
	MusicPlayer.call_deferred("play", 0.0, "MenuTheme")
	

func _new_game() -> void:
	_disable_all_buttons()

	GameSave.set_level(0)
	
	fade_layer.fade_out(fade_color, fade_time)
	MusicPlayer.fade_out()
	
	yield(fade_layer, "faded_out")
	
	get_tree().change_scene_to(intro_story_scene)


func _continue_game() -> void:
	if GameSave.get_level() == 0:
		_new_game()
		return

	_disable_all_buttons()
	
	fade_layer.fade_out(fade_color, fade_time)
	MusicPlayer.fade_out()
	
	yield(fade_layer, "faded_out")
	
	get_tree().change_scene_to(game_scene)


func _show_screen(screen_to_show) -> void:
	for screen in screens_dict.values():
		if screen != screen_to_show:
			screen.hide()
	
	screen_to_show.show()
	
func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton:
		_show_screen(main)
		get_tree().set_input_as_handled()


func _disable_all_buttons() -> void:
	for hboxcontainer in main.get_children():
		var button = hboxcontainer.get_child(3)
		button.set_disabled(true)


func _exit_game() -> void:
	get_tree().quit()

func _PollLink_pressed() -> void:
	OS.shell_open("https://forms.gle/auhz4PorwtGVGCLs8")
