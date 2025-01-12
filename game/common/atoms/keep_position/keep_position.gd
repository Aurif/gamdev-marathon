@tool
extends Node

@export var relative_position: Vector2 = Vector2(0.5, 0.5)

func _ready() -> void:
	if Engine.is_editor_hint():
		get_parent().position = Vector2(get_tree().edited_scene_root.size) * relative_position

	if not Engine.is_editor_hint():
		_on_size_changed()
		get_parent().get_viewport().size_changed.connect(_on_size_changed)


func _on_size_changed():
	get_parent().position = Vector2(get_viewport().get_visible_rect().size) * relative_position
