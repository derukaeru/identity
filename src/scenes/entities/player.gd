class_name Player extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D

var default_speed: float = 3.4
var speed: float = default_speed
@export var gravity: float = 9.8

var mouse_sensitivity: float = 0.002
var can_move: bool = true

var current_interactable: InteractableComponent = null

func _ready() -> void:
	Util.mouse_captured()
	
	EventManager.stop_player_movement.connect(stop_movement)
	EventManager.continue_player_movement.connect(continue_movement)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input = Vector2(Input.get_axis("left", "right"), Input.get_axis("forward", "backward"))
	
	if can_move:
		var direction = (camera.global_transform.basis * Vector3(input.x, 0, input.y)).normalized()
		direction.y = 0
		
		if direction.length() > 0.1:
			direction = direction.normalized()
		
		velocity = direction * speed
	
	move_and_slide()

func _process(_delta: float) -> void:
	var new_interactable: InteractableComponent = null
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is InteractableComponent:
			new_interactable = collider
	
	if new_interactable != current_interactable:
		current_interactable = new_interactable
		if current_interactable:
			EventManager.show_tooltip.emit(current_interactable)
		else:
			EventManager.hide_tooltip.emit()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			_interact()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera.global_rotation.x -= event.relative.y * mouse_sensitivity
		camera.global_rotation.x = clamp(camera.global_rotation.x, -1.3, 1)
		camera.global_rotation.y -= event.relative.x * mouse_sensitivity

func _interact() -> void:
	var collider := raycast.get_collider()
	if collider is InteractableComponent:
		collider.interact()

func stop_movement() -> void:
	can_move = false
	velocity = Vector3.ZERO

func continue_movement() -> void:
	can_move = true
