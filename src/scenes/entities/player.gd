class_name Player extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D
@onready var ui: CanvasLayer = $ui

var camera_tween: Tween

var mouse_sensitivity: float = 0.001
var default_speed: float = 3.4
var speed: float = default_speed

@export var gravity: float = 9.8

var current_interactable: InteractableComponent = null
var item_held: Item = null

var in_dialogue: bool = false
var can_move: bool = true
var inspecting: bool = false
var can_look: bool = true

var default_cam_transform: Transform3D
var inspection_position: Marker3D

func _ready() -> void:
	Util.mouse_captured()
	
	EventManager.stop_player_movement.connect(stop_movement)
	EventManager.continue_player_movement.connect(continue_movement)

	EventManager.open_dialogue.connect(open_dialogue)
	EventManager.close_dialogue.connect(close_dialogue)
	
	EventManager.inspect_visitor.connect(toggle_inspection)
	default_cam_transform = camera.global_transform

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
	if not can_look or inspecting: return
	if event is InputEventMouseMotion:
		camera.global_rotation.x -= event.relative.y * mouse_sensitivity
		camera.global_rotation.x = clamp(camera.global_rotation.x, -1.3, 1)
		camera.global_rotation.y -= event.relative.x * mouse_sensitivity

func _interact() -> void:
	if in_dialogue: return
	
	var collider := raycast.get_collider()
	if collider is Item:
		EventManager.inspect_item.emit(collider)
		#if item_held:
			#item_held.drop()
		#
		#item_held = collider
		#item_held.hide()
	elif collider is InteractableComponent:
		collider.interact()
		return
	else:
		if item_held:
			item_held.use()

func stop_movement() -> void:
	can_move = false
	velocity = Vector3.ZERO

func continue_movement() -> void:
	can_move = true

func close_dialogue() -> void:
	in_dialogue = false
	can_look = true
	continue_movement()

func open_dialogue() -> void:
	in_dialogue = true
	can_look = false
	stop_movement()

func toggle_inspection(marker: Marker3D = null) -> void:
	if not GameManager.has_visitor: return
	
	if camera_tween and camera_tween.is_running():
		camera_tween.kill()
	
	if marker:
		inspection_position = marker
	inspecting = !inspecting
	
	var target_transform: Transform3D
	if inspecting:
		target_transform = inspection_position.global_transform
		can_look = false
		stop_movement()
	else:
		target_transform = default_cam_transform
		can_look = true
		continue_movement()
	
	camera_tween = create_tween()
	camera_tween.set_trans(Tween.TRANS_SINE)
	camera_tween.set_ease(Tween.EASE_IN_OUT)
	camera_tween.tween_property(camera, "global_transform", target_transform, 0.4)
	
	Util.mouse_visible()
