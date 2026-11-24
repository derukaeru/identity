extends CanvasLayer

@onready var pause_screen: Control = $pause_screen
@onready var tooltip: Label = $tooltip

@onready var dialogue_panel: Panel = $dialogue_panel
@onready var dialogue: Label = $dialogue_panel/dialogue

@onready var inspection_ui: Control = $inspection
@onready var object_pivot: Node3D = $inspection/SubViewportContainer/SubViewport/Node3D/ObjectPivot

@onready var questions_container: VBoxContainer = $dialogue_panel/questions

@export var rotation_speed: float = 0.002
var dragging: bool = false

var is_typing: bool = false
var skip_typing: bool = false

var current_dialogue: String = ""
var type_speed: float = 0.01

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	EventManager.show_tooltip.connect(show_tooltip)
	EventManager.hide_tooltip.connect(hide_tooltip)
	EventManager.inspect_item.connect(open_inspection)
	
	clear_dialogue()

func _process(_delta: float) -> void:
	if not GameManager.game_running: return
	
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			pause_screen.close()
			Util.mouse_captured()
			get_tree().paused = false
		else:
			get_tree().paused = true
			pause_screen.open()
			Util.mouse_visible()

func show_tooltip(interactable: InteractableComponent) -> void:
	tooltip.text = interactable.tooltip_text
	tooltip.show()
 
func hide_tooltip() -> void:
	tooltip.hide()

# dialogue

func type_letter(letter: String) -> void:
	dialogue.text += letter

func type_dialogue(dialog: String) -> void:
	if is_typing: return
	clear_dialogue()
	
	for i in range(dialog.length()):
		if skip_typing:
			break
		
		dialogue.text += dialog[i]
		await get_tree().create_timer(type_speed, false).timeout
		
	current_dialogue = dialog
	show_dialogue()
 
func clear_dialogue() -> void:
	dialogue.text = ""
	current_dialogue = ""

func hide_dialogue() -> void:
	dialogue_panel.hide()

func show_dialogue() -> void:
	dialogue_panel.show()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
	
	if event is InputEventMouseMotion and dragging:
		object_pivot.rotate_y(event.relative.x * rotation_speed)
		object_pivot.rotate_x(event.relative.y * rotation_speed)
		
func open_inspection(item: Item = null) -> void:
	inspection_ui.show()
	Util.mouse_visible()
	
	object_pivot.rotation = Vector3.ZERO
	object_pivot.scale = Vector3.ONE
	
	for c in object_pivot.get_children():
		object_pivot.remove_child(c)
		
	object_pivot.add_child(item.duplicate())
	object_pivot.scale = object_pivot.scale * item.item_scale

func _on_exit_pressed() -> void:
	inspection_ui.hide()
	Util.mouse_captured()

func set_questions(questions: Array[String]) -> void:
	var qboxes: Array[Node] = questions_container.get_children()
	for i in range(questions.size()):
		qboxes[i].text = questions[i]
