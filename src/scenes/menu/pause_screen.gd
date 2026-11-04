extends Control

func _on_resume_pressed() -> void:
	get_tree().paused = false
	Util.mouse_captured()
	hide()

func _on_settings_pressed() -> void:
	pass

func _on_exit_pressed() -> void:
	SceneChanger.change_scene("title_screen")
	
func open() -> void:
	show()

func close() -> void:
	hide()
