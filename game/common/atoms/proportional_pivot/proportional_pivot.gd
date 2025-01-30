extends Node

@export var proportional_position: Vector2

func _ready() -> void:
	_on_size_changed()

	if not Engine.is_editor_hint():
		(get_parent() as Control).resized.connect(_on_size_changed)


func _on_size_changed():
	(get_parent() as Control).pivot_offset = get_parent().size*proportional_position
