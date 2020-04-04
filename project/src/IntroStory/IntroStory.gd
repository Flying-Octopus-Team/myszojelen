extends Control

signal next_screen_requested

onready var fade_layer = $FadeLayer
onready var arrow_btn = $NextArrow
onready var play_btn = $PlayBtn

export(Array, Color) var fade_colors
export var fade_time : float = 1.0

onready var story_screens = [
	$Story1,
	$Story2,
	$Story3
]

var current_screen = 0

var is_loading_game := false
var game_scene = preload("res://src/Game/Game.tscn")


func _ready() -> void:
	for i in range(1, story_screens.size()):
		var screen = story_screens[i]
		screen.hide()
	
	arrow_btn.show()
	play_btn.hide()
	
#	fade_layer.connect("faded_out", self, "_on_faded_out")
	
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
	
	yield(fade_layer, "faded_in")
	yield(self, "next_screen_requested")
	
	fade_layer.fade_out(Color.black, fade_time)
	
	yield(fade_layer, "faded_out")
	
	load_game()


func _on_faded_out() -> void:
	if current_screen < story_screens.size():
		fade_layer.fade_in(fade_colors[current_screen], fade_time)
		
		if current_screen > 1:
			story_screens[current_screen-1].hide()
			
			if current_screen == story_screens.size()-1:
				arrow_btn.hide()
				play_btn.show()
		
		story_screens[current_screen].show()
	else:
		load_game()


func next_screen() -> void:
	current_screen += 1
	
	if current_screen >= story_screens.size():
		set_process(false)
		fade_layer.fade_out(Color.black, fade_time)
		return
	
	fade_layer.fade_out(fade_colors[current_screen], fade_time)


func _process(delta) -> void:
	if Input.is_action_just_pressed("next_slide"):
#		next_screen()
		emit_signal("next_screen_requested")


func load_game() -> void:
	get_tree().change_scene_to(game_scene)
