extends Node

var game_running: bool = true
var current_map: String = "inspection_booth"

var day_running: bool = true
var has_visitor: bool = false

var max_time: float = 1600.0 # seconds
var time: float = 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	EventManager.visitor_waiting.connect(visitor_waiting)
	EventManager.visitor_entered.connect(visitor_entered)
	EventManager.visitor_left.connect(visitor_left)

func visitor_waiting() -> void:
	has_visitor = true

func visitor_left() -> void:
	has_visitor = false
	
func visitor_entered() -> void:
	has_visitor = false
