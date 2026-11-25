extends InteractableComponent

@onready var animation: AnimationPlayer = $bar_pivot/AnimationPlayer

func interact() -> void:
	animation.play("toggle")
	await animation.animation_finished
	
	interacted.emit()
	animation.play_backwards("toggle")
	
