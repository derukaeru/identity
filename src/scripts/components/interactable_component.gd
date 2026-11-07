class_name InteractableComponent extends Area3D

signal interacted

@export var tooltip_text: String = "RMB to interact"
@export var show_tooltip: bool = true

func interact() -> void:
	interacted.emit()
