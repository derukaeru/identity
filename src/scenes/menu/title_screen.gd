extends Control

func _on_start_pressed() -> void:
	GameManager.current_map = "house"
	SceneChanger.change_scene("main")

func _on_settings_pressed() -> void:
	pass

func _on_exit_pressed() -> void:
	pass
