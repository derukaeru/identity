class_name Visitor extends PathFollow3D

enum STATES {
	IDLE,
	ENTERING,
	WAITING,
	LEAVING
}

@export var state: STATES = STATES.IDLE
@export var personality: VisitorData.Personalities = VisitorData.Personalities.NEUTRAL

@export var data: VisitorData
@export var answers: Array[String] = []

var gave_id: bool = false
var accepted: bool = false

@export var speed: float = 2.0

func _ready() -> void:
	EventManager.approve_visitor.connect(approved)
	EventManager.deny_visitor.connect(denied)
	EventManager.ask_question.connect(asked_question)
	
	if data:
		answers = data.answers

func _process(delta: float) -> void:
	match state:
		STATES.IDLE:
			state = STATES.ENTERING
			EventManager.move_visitor.emit(self)
		STATES.LEAVING:
			progress += speed * delta
			
			if has_arrived():
				if approved:
					EventManager.visitor_entered.emit()
				else:
					EventManager.visitor_left.emit()
				queue_free()
		STATES.ENTERING:
			progress += speed * delta
			
			if has_arrived():
				state = STATES.WAITING
				EventManager.visitor_waiting.emit()
				EventManager.move_visitor.emit(self)
		STATES.WAITING:
			if gave_id: return
			
			gave_id = true
			give_id()

func approved() -> void:
	if state != STATES.WAITING: return
	state = STATES.LEAVING
	accepted = true
	EventManager.move_visitor.emit(self)

func denied() -> void:
	if state != STATES.WAITING: return
	state = STATES.LEAVING
	accepted = false
	EventManager.move_visitor.emit(self)

func _on_interactable_component_interacted() -> void:
	EventManager.dialogue.emit("Hello.")

func has_arrived() -> bool:
	if progress_ratio < 1.0: return false
	return true

func give_id() -> void:
	var id: Item = load(Registry.UID["id"]).instantiate()
	EventManager.add_item.emit(id)
	gave_id = true

func asked_question(index: int) -> void:
	if index >= answers.size(): 
		EventManager.dialogue.emit("...")
	else: EventManager.dialogue.emit(answers[index])
