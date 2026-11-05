class_name WindowScreen extends Control

func _ready() -> void:
	EventManager.open_inspection_window.connect(open)
	EventManager.close_inspection_window.connect(close)

func open() -> void:
	show()
	Util.mouse_visible()
	EventManager.stop_player_movement.emit()

func close() -> void:
	hide()
	Util.mouse_captured()
	EventManager.continue_player_movement.emit()
