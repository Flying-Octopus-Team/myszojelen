extends CanvasLayer

onready var trees_left_label : Label = find_node("TreesLeft")
onready var game_over_screen : Popup = $Control/GameOverWindow

const TEES_LEFT_PREFIX := "Pozostalo drzew: "


func set_trees_left(tres_left:int) -> void:
	trees_left_label.text = TEES_LEFT_PREFIX + str(tres_left)


func _on_game_over() -> void:
	game_over_screen.show()
