extends Node

@export var game: Node

func _ready() -> void:
	(get_parent() as Area2D).mouse_entered.connect(_on_mouse_entered)

func _on_mouse_entered() -> void:
	game.on_sector_selected(get_parent().get_node("Polygon2D"))
