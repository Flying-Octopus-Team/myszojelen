extends MenuButton

var popup_menu : PopupMenu = get_popup()
var is_popup_active : bool = false

var gui_steering = GUISteering.new()

func handle_on_focus_entered() -> void:
	set_scale(Vector2(1.3, 1.3))

func handle_on_focus_exited() -> void:
	set_scale(Vector2.ONE)

func handle_action(action: int) -> void:
	if action == GUISteering.gui_actions.press:
		is_popup_active = true
		popup_menu.popup_centered()
		grab_focus()

func _gui_input(event):
	match gui_steering.get_action(event):
		gui_steering.gui_actions.down:
			print("donw")
			popup_menu.emit_signal("id_focused", popup_menu.get_item_id(popup_menu.get_current_index()+1))

		gui_steering.gui_actions.up:
			print("up")
			popup_menu.emit_signal("id_focused", popup_menu.get_item_id(popup_menu.get_current_index()+1))

		gui_steering.gui_actions.press:
			print("press")
			popup_menu.emit_signal("index_pressed", popup_menu.get_current_index())
