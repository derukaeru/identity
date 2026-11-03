class_name Player extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D

var default_speed: float = 3.4
var speed: float = default_speed
@export var gravity: float = 9.8

var mouse_sensitivity: float = 0.003
var can_move: bool = true

func _ready() -> void:
	Util.mouse_captured()

func _physics_process(delta) -> void:
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

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera.global_rotation.x -= event.relative.y * mouse_sensitivity
		camera.global_rotation.x = clamp(camera.global_rotation.x, -1.3, 1)
		camera.global_rotation.y -= event.relative.x * mouse_sensitivity

func stop_movement() -> void:
	can_move = false
	velocity = Vector3.ZERO

func set_movement() -> void:
	can_move = true
