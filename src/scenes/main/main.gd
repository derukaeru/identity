extends Node3D

func _init() -> void:
	var map: Node3D = load(Registry.UID[GameManager.current_map]).instantiate()
	add_child(map)
