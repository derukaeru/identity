extends Node

signal show_tooltip(interactable: InteractableComponent)
signal hide_tooltip

signal open_inspection_window
signal close_inspection_window

signal stop_player_movement
signal continue_player_movement

signal open_pause
signal close_pause

signal stop_player
signal move_player

signal move_visitor(visitor: Visitor)
signal add_object(object: Item)
signal add_item(item: Item)

signal inspect_item(item: Item)

signal deny_visitor
signal approve_visitor
