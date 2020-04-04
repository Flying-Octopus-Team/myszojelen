extends CanvasLayer

signal next_level_requested
signal replay_requested

onready var trees_left_label : Label = find_node("TreesLeft")
onready var game_over_screen : Control = $Control/GameOverScreen
onready var level_won_screen : Control = $Control/LevelWonScreen
onready var end_of_game_screen : Control = $Control/EndOfGameScreen

const TEES_LEFT_PREFIX := "Pozostalo drzew: "


func _ready() -> void:
	reset()


func set_trees_left(tres_left:int) -> void:
	trees_left_label.text = TEES_LEFT_PREFIX + str(tres_left)


func reset() -> void:
	game_over_screen.hide()
	level_won_screen.hide()
	end_of_game_screen.hide()


func _on_game_over() -> void:
	game_over_screen.show()


func _on_level_won() -> void:
	level_won_screen.show()


func _on_end_of_levels() -> void:
	end_of_game_screen.show()


func _on_ReplayBtn_pressed():
	emit_signal("replay_requested")


func _on_NextLevelBtn_pressed():
	emit_signal("next_level_requested")
