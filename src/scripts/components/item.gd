class_name Item extends InteractableComponent

@export var item_name: String = ""
@export var item_scale: float = 1.0

func _ready() -> void:
	pass

func use() -> void:
	pass

func drop() -> void:
	show()
