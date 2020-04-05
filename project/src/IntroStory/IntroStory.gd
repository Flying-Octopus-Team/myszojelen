extends Control

signal next_screen_requested

onready var fade_layer = $FadeLayer
onready var arrow_btn = $NextArrow
onready var play_btn = $PlayBtn

onready var developers_screen = $DevelopersScreen

export(Array, Color) var fade_colors
export var fade_time : float = 1.0

onready var story_screens = [
	$Story1,
	$Story2,
	$Story3
]

var current_screen = 0

var game_scene = preload("res://src/Game/Game.tscn")


func _ready() -> void:
	OS.window_maximized = true
	
	for i in range(1, story_screens.size()):
		var screen = story_screens[i]
		screen.hide()
	
	arrow_btn.show()
	play_btn.hide()
	
	start()


func start() -> void:
	fade_layer.fade_in(fade_colors[0], fade_time)
	story_screens[0].show()
	
	yield(fade_layer, "faded_in")
	yield(self, "next_screen_requested")
	
	fade_layer.fade_out(fade_colors[1], fade_time)
	
	yield(fade_layer, "faded_out")
	
	fade_layer.fade_in(fade_colors[1], fade_time)
	story_screens[1].show()
	
	yield(fade_layer, "faded_in")
	yield(self, "next_screen_requested")
	
	fade_layer.fade_out(fade_colors[2], fade_time)
	
	yield(fade_layer, "faded_out")
	
	fade_layer.fade_in(fade_colors[2], fade_time)
	story_screens[2].show()
	arrow_btn.hide()
	play_btn.show()
	
	yield(fade_layer, "faded_in")
	yield(self, "next_screen_requested")
	
	fade_layer.fade_out(Color.black, fade_time)
	
	yield(fade_layer, "faded_out")
	
	load_game()


func _unhandled_input(event) -> void:
	if developers_screen.visible:
		return
	
	if Input.is_action_just_pressed("next_slide"):
		emit_signal("next_screen_requested")


func load_game() -> void:
	get_tree().change_scene_to(game_scene)


func _on_Button_pressed():
	developers_screen.show()


func _on_NextArrow_pressed():
	emit_signal("next_screen_requested")


func _on_PlayBtn_pressed():
	load_game()
