extends Node

signal game_over
signal level_won
signal end_of_levels

export var fade_color : Color
export var end_delay_time := 1.0

onready var world : Node = $World
onready var interface : CanvasLayer = $Interface
onready var fade_layer = $FadeLayer

var trees_left : int setget set_trees_left
var enemies_left : int setget set_enemies_left
var timer_time : float setget set_timer_time

var _is_game_running : bool = false

var is_level_won : bool = false

func _ready() -> void:
	world.connect("tree_cut", self, "_on_tree_cut")
	world.connect("level_won", self, "_on_level_won")
	world.connect("end_of_levels", self, "_on_end_of_levels")
	connect("game_over", interface, "_on_game_over")
	connect("level_won", interface, "_on_level_won")
	connect("end_of_levels", interface, "_on_end_of_levels")
	
	interface.connect("next_level_requested", self, "_on_next_level_requested")
	interface.connect("replay_requested", self, "_on_replay_requested")
	interface.connect("reset_game_requested", self, "_on_reset_game_requested")
	
	_start()


func _process(delta):
	if _is_game_running:
		set_timer_time(timer_time+delta)


func _start() -> void:
	
	_start_game()
	
	fade_layer.fade_in(fade_color)
	yield(fade_layer, "faded_in")


func _start_game() -> void:
	MusicPlayer.play(0.0, "MainTheme")
	
	interface.reset()
	
	_next_level()


func set_trees_left(value: int) -> void:
	trees_left = value
	interface.set_trees_left(trees_left)

func set_enemies_left(value: int) -> void:
	enemies_left = value
	interface.set_enemies_left(enemies_left)


func set_timer_time(value: float) -> void:
	timer_time = value
	interface.set_timer(timer_time)


func _on_tree_cut() -> void:
	if not _is_game_running:
		return
	
		trees_left -= 1
		interface.set_trees_left(trees_left)
	
	if trees_left <= 0:
		_is_game_running = false
		MusicPlayer.fade_out()
		_fade("_game_over")


func on_enemy_died() -> void:
	set_enemies_left(enemies_left-1)

func _game_over() -> void:
	is_level_won = false

	MusicPlayer.play(0.0, "LoseTheme")
	emit_signal("game_over")


func _on_level_won() -> void:
	if not _is_game_running:
		return

	is_level_won = true
	
	MusicPlayer.fade_out()

	GameSave.next_level()
	
	yield(get_tree().create_timer(end_delay_time), "timeout")
	
	_is_game_running = false
	_fade("_show_next_level_screen")


func _show_next_level_screen() -> void:
	MusicPlayer.play(0.0, "MenuTheme")
	emit_signal("level_won")


func _on_end_of_levels() -> void:
	yield(get_tree().create_timer(end_delay_time), "timeout")
	
	_fade("_finish_game")


func _finish_game() -> void:
	MusicPlayer.play(0.0, "MenuTheme")
	emit_signal("end_of_levels")


func _on_next_level_requested() -> void:
	MusicPlayer.fade_out()
	_fade("_next_level", true)


func _next_level() -> void:
	get_tree().paused = true
	MusicPlayer.play(0.0, "MainTheme")
	interface.reset()
	world.next_level()
	
	set_trees_left(world.count_trees())
	set_enemies_left(world.count_enemies())
	set_timer_time(0.0)
	_is_game_running = true


func _on_replay_requested() -> void:
	MusicPlayer.fade_out()
	_fade("_reset_level", true)


func _reset_level() -> void:
	get_tree().paused = true
	MusicPlayer.play(0.0, "MainTheme")
	
	interface.reset()
	world.reset_level()
	set_trees_left(world.count_trees())
	set_enemies_left(world.count_enemies())
	set_timer_time(0.0)
	_is_game_running = true


func _on_reset_game_requested() -> void:
	GameSave.set_level(0)
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
