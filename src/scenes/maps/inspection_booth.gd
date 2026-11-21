extends Node3D

@onready var idle_path: Node3D = $idle_path
@onready var enter_path: Path3D = $enter_path
@onready var leave_path: Path3D = $leave_path
@onready var accept_path: Path3D = $accept_path

@onready var visitor_spawn: Node3D = $visitor_spawn

func _ready() -> void:
	EventManager.move_visitor.connect(move_visitor)
	spawn_visitor()

func move_visitor(visitor: Visitor) -> void:
	var state: Visitor.STATES = visitor.state
	
	match state:
		Visitor.STATES.WAITING:
			visitor.reparent(idle_path)
		Visitor.STATES.LEAVING:
			if visitor.accepted:
				visitor.reparent(accept_path)
			else:
				visitor.reparent(leave_path)
		Visitor.STATES.ENTERING:
			visitor.reparent(enter_path)

func spawn_visitor() -> void:
	var visitor: Visitor = load(Registry.UID["visitor"]).instantiate()
	idle_path.add_child(visitor)
