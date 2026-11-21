extends Node

var level: int = 1
var locked_levels: Array = [true, true, true, true]

var game_running: bool = true
var current_map: String = "house"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
