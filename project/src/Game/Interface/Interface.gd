extends CanvasLayer

signal next_level_requested
signal replay_requested
signal reset_game_requested

onready var trees_left_label : Label = $Control/HUD/VBoxContainer/TreesRect/HBoxContainer/Label
onready var enemies_left_label : Label = $Control/HUD/VBoxContainer/EnemiesRect/HBoxContainer/Label
onready var timer_label : Label = $Control/HUD/VBoxContainer/TimerRect/HBoxContainer/Label
onready var game_over_screen : Control = $Control/GameOverScreen
onready var level_won_screen : Control = $Control/LevelWonScreen
onready var end_of_game_screen : Control = $Control/EndOfGameScreen
onready var HUD : Control = $Control/HUD

onready var settings_screen : Control = $Settings

onready var developers_screen = $DevelopersScreen

enum Screen { NONE, LEVEL_WON, GAME_OVER, END_OF_GAME }
var current_screen : int = Screen.NONE

func _ready() -> void:
	$Control/LevelWonScreen/ReplayBtn.connect("pressed", self, "_on_ReplayBtn_pressed")
	HUD.get_node("PauseBtn").connect("pressed", settings_screen.get_node("TextureRect/PauseScreen"), "show")
	reset()


func set_trees_left(tres_left:int) -> void:
	trees_left_label.text = str(tres_left)

func set_enemies_left(enemies_left:int) -> void:
	enemies_left_label.text = str(enemies_left)


func set_timer(timer_time: float) -> void:
	timer_time = stepify(timer_time, 0.01)

	var minutes = min(int(floor(timer_time/60.0)), 60)
	var seconds = fmod(timer_time, 60.0)

	timer_label.text = str(minutes).pad_zeros(2) + ":" + str(seconds)


func reset() -> void:
	game_over_screen.hide()
	level_won_screen.hide()
	end_of_game_screen.hide()
	
	HUD.hide()
	$SteeringScreen.hide()
	
	settings_screen.hide()
	
	developers_screen.visible = false
	current_screen = Screen.NONE


func _unhandled_input(event) -> void:
	if current_screen == Screen.NONE:
		return
	
	if developers_screen.visible:
		return
	
	if Input.is_action_just_pressed("next_slide"):
		match current_screen:
			Screen.LEVEL_WON:
				emit_signal("next_level_requested")
			Screen.GAME_OVER:
				emit_signal("replay_requested")
			Screen.END_OF_GAME:
				emit_signal("reset_game_requested")


func _on_game_over() -> void:
	game_over_screen.show()
	current_screen = Screen.GAME_OVER


func _on_level_won() -> void:
	level_won_screen.show()
	current_screen = Screen.LEVEL_WON


func _on_end_of_levels() -> void:
	end_of_game_screen.show()
	current_screen = Screen.END_OF_GAME


func _on_NextLevelBtn_pressed():
	emit_signal("next_level_requested")


func _on_ReplayBtn_pressed():
	emit_signal("replay_requested")


func _on_ResetGameBtn_pressed():
	emit_signal("reset_game_requested")


func _on_DevelopersButton_pressed():
	developers_screen.show()
