extends InteractableComponent

@export var move_to: String = ""

func _on_interacted() -> void:
	if move_to.is_empty() or not Registry.UID.has(move_to): return
	GameManager.current_map = move_to
	SceneChanger.change_scene("main")
