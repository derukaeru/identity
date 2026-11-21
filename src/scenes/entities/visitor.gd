class_name Visitor extends PathFollow3D

enum STATES {
	IDLE,
	ENTERING,
	WAITING,
	LEAVING
}

enum PERSONALITY {
	NEUTRAL,
	CALM,
	AGGRESSIVE,
	NERVOUS,
	CONFUSED,
	EVASIVE
}

@export var state: STATES = STATES.IDLE
@export var personality: PERSONALITY = PERSONALITY.NEUTRAL

var gave_id: bool = false
var accepted: bool = false

@export var speed: float = 4.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	match state:
		STATES.IDLE:
			state = STATES.ENTERING
			EventManager.move_visitor.emit(self)
		STATES.LEAVING:
			progress += speed * delta
			
			if has_arrived():
				queue_free()
		STATES.ENTERING:
			progress += speed * delta
			
			if has_arrived():
				state = STATES.WAITING
				EventManager.move_visitor.emit(self)
		STATES.WAITING:
			if gave_id: return
			
			gave_id = true
			give_id()

func inspect(approved: bool = false) -> void:
	pass

func _on_interactable_component_interacted() -> void:
	state = STATES.LEAVING
	EventManager.move_visitor.emit(self)

func has_arrived() -> bool:
	if progress_ratio < 1.0: return false
	return true

func give_id() -> void:
	var id: Item = load(Registry.UID["id"]).instantiate()
	EventManager.add_item.emit(id)
