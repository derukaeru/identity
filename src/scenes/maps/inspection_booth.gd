extends Node3D

@onready var idle_path: Node3D = $idle_path
@onready var enter_path: Path3D = $enter_path
@onready var leave_path: Path3D = $leave_path
@onready var accept_path: Path3D = $accept_path

@onready var visitor_spawn: Node3D = $visitor_spawn
@onready var objects: Node3D = $objects
@onready var items: Node3D = $items

@onready var deny_button_animation: AnimationPlayer = $objects/deny/DenyButtonAnimation
@onready var approve_button_animation: AnimationPlayer = $objects/approve/ApproveButtonAnimation

func _ready() -> void:
	EventManager.move_visitor.connect(move_visitor)
	EventManager.add_item.connect(add_item)
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
			visitor.progress_ratio = 0.0
		Visitor.STATES.ENTERING:
			visitor.reparent(enter_path)
			visitor.progress_ratio = 0.0

func spawn_visitor() -> void:
	var visitor: Visitor = load(Registry.UID["visitor"]).instantiate()
	idle_path.add_child(visitor)

func add_item(item: Item) -> void:
	items.add_child(item)

func _on_deny_interacted() -> void:
	EventManager.deny_visitor.emit()
	deny_button_animation.play("click")

func _on_approve_interacted() -> void:
	EventManager.approve_visitor.emit()
	approve_button_animation.play("click")
	
func _on_lever_interacted() -> void:
	# inspect symptoms
	pass
