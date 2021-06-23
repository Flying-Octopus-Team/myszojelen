extends Control

signal next_screen_requested

onready var fade_layer = $FadeLayer
onready var arrow_btn = $NextArrow
onready var play_btn = $PlayBtn

onready var developers_screen = $DevelopersScreen

onready var change_screen_sound = $ChangeScreenSound

export(Array, Color) var fade_colors
export var fade_time : float = 1.0
export var start_fade_time : float = 1.0

onready var story_screens = [
	$Story1,
	$Story2,
	$Story3
]

var current_screen = 0

var game_scene = preload("res://src/Game/Game.tscn")


func _ready() -> void:
	for i in range(1, story_screens.size()):
		var screen = story_screens[i]
		screen.hide()

	change_screen_sound.set_volume_db(linear2db(Settings.audio_effects_volume))
	$ClickSound.set_volume_db(Settings.audio_effects_volume)
	
	arrow_btn.show()
	play_btn.hide()
	
	call_deferred("start")
	MusicPlayer.call_deferred("play", 0.0, "Oriental")

	story_screens[2].texture = load(tr("INTRO_STORY_TEXTURE_KEY"))


func start() -> void:
	_show_screen(0, start_fade_time)
	
	yield(fade_layer, "faded_in")
	
	change_screen_sound.play()
	
	yield(self, "next_screen_requested")
	
	_fade_out(1)
	
	yield(fade_layer, "faded_out")
	
	_show_screen(1)
	
	yield(fade_layer, "faded_in")
	yield(self, "next_screen_requested")
	
	_fade_out(2)
	
	yield(fade_layer, "faded_out")
	
	_show_screen(2)
	
	arrow_btn.hide()
	play_btn.show()
	
	yield(fade_layer, "faded_in")
	yield(self, "next_screen_requested")
	
	change_screen_sound.play()
	fade_layer.fade_out(Color.black, fade_time)
	
	yield(fade_layer, "faded_out")
	
	load_game()


func _fade_out(color_id:int) -> void:
	change_screen_sound.play()
	fade_layer.fade_out(fade_colors[2], fade_time)


func _show_screen(screen_id:int, custom_fade_time:float=fade_time) -> void:
	fade_layer.fade_in(fade_colors[screen_id], custom_fade_time)
	story_screens[screen_id].show()


func _unhandled_input(event) -> void:
	if developers_screen.visible:
		return
	
	if Input.is_action_just_pressed("next_slide"):
		emit_signal("next_screen_requested")


func load_game() -> void:
	get_tree().change_scene_to(game_scene)


func _on_NextArrow_pressed():
	emit_signal("next_screen_requested")


func _on_PlayBtn_pressed():
	load_game()


func _on_DevelopersButton_pressed():
	developers_screen.show()
