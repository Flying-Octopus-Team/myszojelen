extends Control

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

var current_screen = -1

var game_scene = preload("res://src/Game/Game.tscn")


func _ready() -> void:
	for i in range(1, story_screens.size()):
		var screen = story_screens[i]
		screen.hide()
	
	arrow_btn.show()
	play_btn.hide()
	
	set_current_screen(0)
	
	fade_layer.connect("faded_out", self, "_on_faded_out")


func _on_faded_out() -> void:
	if current_screen < story_screens.size()-1:
		set_current_screen(current_screen+1)
	else:
		finish_story()


func set_current_screen(nr:int) -> void:
	current_screen = nr
	fade_layer.fade_in(fade_colors[nr], fade_time)
	
	if current_screen > 1:
		story_screens[current_screen-1].hide()
		
		if current_screen == story_screens.size()-1:
			arrow_btn.hide()
			play_btn.show()
	
	story_screens[current_screen].show()


func next_screen() -> void:
	var next_screen_idx = current_screen + 1
	
	if next_screen_idx >= story_screens.size():
		fade_layer.fade_out(Color.black)
		return
	
	fade_layer.fade_out(fade_colors[next_screen_idx], fade_time)


func _process(delta) -> void:
	if Input.is_action_just_pressed("next_slide"):
		next_screen()


func finish_story() -> void:
	get_tree().change_scene_to(game_scene)
