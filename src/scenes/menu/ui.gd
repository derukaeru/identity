extends CanvasLayer

@onready var pause_screen: Control = $pause_screen

func _process(_delta: float) -> void:
	if not GameManager.game_running or get_tree().paused: return
	
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			Util.mouse_captured()
			get_tree().paused = false
			pause_screen.close()
		else:
			get_tree().paused = true
			pause_screen.open()
			Util.mouse_visible()
