extends CanvasLayer

signal next_level_requested
signal replay_requested
signal reset_game_requested

onready var trees_left_label : Label = find_node("TreesLeft")
onready var game_over_screen : Control = $Control/GameOverScreen
onready var level_won_screen : Control = $Control/LevelWonScreen
onready var end_of_game_screen : Control = $Control/EndOfGameScreen
#onready var steering_screen : Control = $SteeringScreen
onready var HUD : MarginContainer = $Control/HUD

onready var developers_screen = $DevelopersScreen

const TEES_LEFT_PREFIX := "Pozostalo drzew: "

enum Screen { NONE, LEVEL_WON, GAME_OVER, END_OF_GAME }
var current_screen : int = Screen.NONE

func _ready() -> void:
	$Control/EndOfGameScreen/PollLink.connect("pressed", self, "_on_PollLink_pressed")
	$Control/LevelWonScreen/ReplayBtn.connect("pressed", self, "_on_ReplayBtn_pressed")
	reset()


func set_trees_left(tres_left:int) -> void:
	trees_left_label.text = TEES_LEFT_PREFIX + str(tres_left)


func reset() -> void:
	game_over_screen.hide()
	level_won_screen.hide()
	end_of_game_screen.hide()
	
	HUD.hide()
	$SteeringScreen.hide()
	$SteeringScreen/SteeringContainer.reset()
	$SteeringScreen/ContinueBtn.disabled = true
	
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
	
	
func _on_PollLink_pressed() -> void:
	OS.shell_open("https://www.example.com/")
