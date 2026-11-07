extends CanvasLayer

@onready var pause_screen: Control = $pause_screen
@onready var tooltip: Label = $tooltip

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	EventManager.show_tooltip.connect(show_tooltip)
	EventManager.hide_tooltip.connect(hide_tooltip)

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
