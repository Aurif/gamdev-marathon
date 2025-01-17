extends Node

@export var max_move: Vector2
@export var respect_scale: bool = true
var base_pos: Vector2

func _ready() -> void:
	base_pos = get_parent().position
	if respect_scale:
		max_move *= get_parent().scale*get_parent().scale

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion:
		return
	var cursor_offset = event.position/get_viewport().get_visible_rect().size - Vector2(0.5, 0.5)
	get_parent().position = base_pos - max_move*cursor_offset*2
