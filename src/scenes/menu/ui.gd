extends CanvasLayer


@onready var pause_screen: Control = $pause_screen
@onready var tooltip: Label = $tooltip

@onready var dialogue_container: Control = $dialogue_container
@onready var dialogue: Label = $dialogue_container/dialogue_panel/dialogue

@onready var inspection_ui: Control = $inspection
@onready var object_pivot: Node3D = $inspection/SubViewportContainer/SubViewport/Node3D/ObjectPivot

@onready var questions_container: VBoxContainer = $dialogue_container/dialogue_panel/questions
@onready var continue_icon: TextureRect = $dialogue_container/dialogue_panel/continue

@export var rotation_speed: float = 0.002
var dragging: bool = false

var is_typing: bool = false
var skip_typing: bool = false

var current_dialogue: String = ""
var type_speed: float = 0.02

var questions: Array[String] = [
	"",
	"",
	""
]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	EventManager.show_tooltip.connect(show_tooltip)
	EventManager.hide_tooltip.connect(hide_tooltip)
	EventManager.inspect_item.connect(open_inspection)
	EventManager.dialogue.connect(type_dialogue)
	
	EventManager.dialogue_finished.connect(_dialogue_finished)
	
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
	
	current_dialogue = dialog
	show_dialogue()
	
	for i in range(dialog.length()):
		if skip_typing:
			break
		
		dialogue.text += dialog[i]
		await get_tree().create_timer(type_speed, false).timeout
	
	is_typing = false
	skip_typing = false
	
	EventManager.dialogue_finished.emit()
 
func clear_dialogue() -> void:
	dialogue.text = ""
	current_dialogue = ""
	continue_icon.hide()

func hide_dialogue() -> void:
	dialogue_container.hide()
	Util.mouse_captured()
	
	clear_dialogue()
	EventManager.close_dialogue.emit()

func show_dialogue() -> void:
	dialogue_container.show()
	Util.mouse_visible()
	continue_icon.hide()
	EventManager.open_dialogue.emit()

func _dialogue_finished() -> void:
	questions_container.show()
	continue_icon.show()

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

func set_questions() -> void:
	var qboxes: Array[Node] = questions_container.get_children()
	for i in range(questions.size()):
		qboxes[i].text = questions[i]

func ask_question(index: int) -> void:
	if index >= questions.size(): return
	EventManager.ask_question.emit(index)
	
	questions_container.hide()

func dialogue_panel_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if is_typing:
			skip_typing = true
		else:
			hide_dialogue()
