extends Node

@export var anchor_name: String

func _ready() -> void:
	QuarkAnchor.set_anchor(anchor_name, get_parent())
