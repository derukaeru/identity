extends Area3D

@export var move_to: String = ""

func _on_input_event(_c: Node, event: InputEvent, _ep: Vector3, _n: Vector3, _sid: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_RIGHT and not event.is_echo() and event.is_pressed():
			move()

func move() -> void:
	if move_to.is_empty() or not Registry.UID.has(move_to): return
	
	SceneChanger.change_scene("main")
