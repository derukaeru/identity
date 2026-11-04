extends Node

var level: int = 1
var locked_levels: Array = [true, true, true, true]

@onready var ui: CanvasLayer = load(Registry.UID["ui"]).instantiate()
var canvas: CanvasLayer = CanvasLayer.new()

var game_running: bool = true

func _ready() -> void:
	add_child(canvas)
	canvas.add_child(ui)

	process_mode = Node.PROCESS_MODE_ALWAYS
