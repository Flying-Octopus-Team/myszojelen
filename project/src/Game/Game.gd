extends Node

signal game_over
signal level_won
signal end_of_levels

export var fade_color : Color
export var end_delay_time := 1.0

onready var world : Node = $World
onready var interface : CanvasLayer = $Interface
onready var fade_layer = $FadeLayer

onready var main_theme = $MainTheme
onready var menu_theme = $MenuTheme
onready var lose_music = $LoseMusic

var trees_left : int

var _is_game_running : bool = false

var level_counter : int = 1

func _ready() -> void:
	world.connect("tree_cutted", self, "_on_tree_cutted")
	world.connect("level_won", self, "_on_level_won")
	world.connect("end_of_levels", self, "_on_end_of_levels")
	connect("game_over", interface, "_on_game_over")
	connect("level_won", interface, "_on_level_won")
	connect("end_of_levels", interface, "_on_end_of_levels")
	
	interface.connect("next_level_requested", self, "_on_next_level_requested")
	interface.connect("replay_requested", self, "_on_replay_requested")
	interface.connect("reset_game_requested", self, "_on_reset_game_requested")
	
	_start()


func _start() -> void:
	
	_start_game()
	
	fade_layer.fade_in(fade_color)
	yield(fade_layer, "faded_in")


func _start_game() -> void:
	lose_music.force_stop()
	menu_theme.force_stop()
	main_theme.play()
	
	interface.reset()
	world.reset()
	_next_level()


func _prepare_trees_left() -> void:
	trees_left = world.count_trees()
	interface.set_trees_left(trees_left)


func _on_tree_cutted() -> void:
	if not _is_game_running:
		return
	
	trees_left -= 1
	interface.set_trees_left(trees_left)
	
	if trees_left <= 0:
		_is_game_running = false
		main_theme.fade_out()
		_fade("_game_over")


func _game_over() -> void:
	main_theme.force_stop()
	lose_music.play()
	emit_signal("game_over")


func _on_level_won() -> void:
	if not _is_game_running:
		return
	
	main_theme.fade_out()
	
	yield(get_tree().create_timer(end_delay_time), "timeout")
	
	_is_game_running = false
	level_counter += 1
	_fade("_show_next_level_screen")


func _show_next_level_screen() -> void:
	main_theme.force_stop()
	menu_theme.play()
	emit_signal("level_won")


func _on_end_of_levels() -> void:
	yield(get_tree().create_timer(end_delay_time), "timeout")
	
	_fade("_finish_game")


func _finish_game() -> void:
	main_theme.force_stop()
	menu_theme.play()
	emit_signal("end_of_levels")


func _on_next_level_requested() -> void:
	lose_music.force_stop()
	menu_theme.fade_out()
	_fade("_next_level", true)


func _next_level() -> void:
	get_tree().paused = true
	menu_theme.force_stop()
	main_theme.play()
	interface.reset()
	world.next_level()
	
	_prepare_trees_left()
	_is_game_running = true


func _on_replay_requested() -> void:
	lose_music.fade_out()
	_fade("_reset_level", true)


func _reset_level() -> void:
	get_tree().paused = true
	lose_music.force_stop()
	main_theme.play()
	
	interface.reset()
	world.reset_level()
	_prepare_trees_left()
	_is_game_running = true


func _on_reset_game_requested() -> void:
	_fade("_start_game", true)


func _fade(callback:String, keep_tree_paused: bool = false) -> void:
	get_tree().paused = true
	
	fade_layer.fade_out(fade_color)
	yield(fade_layer, "faded_out")
	
	call(callback)
	
	fade_layer.fade_in(fade_color)
	yield(fade_layer, "faded_in")
	
	if (get_tree().paused):
		get_tree().paused = keep_tree_paused
