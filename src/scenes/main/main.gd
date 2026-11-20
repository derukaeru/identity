extends Node3D

@onready var ui: CanvasLayer = load(Registry.UID["ui"]).instantiate()
var canvas: CanvasLayer = CanvasLayer.new()

func _ready() -> void:
	add_child(canvas)
	canvas.add_child(ui)
