class_name InteractableComponent extends Area3D

signal interacted

func interact() -> void:
	interacted.emit()
