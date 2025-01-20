extends Node

@export var hide_cursor: bool = true

func _ready() -> void:
	if hide_cursor:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_parent().position = get_viewport().get_mouse_position()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		get_parent().position = event.position
