extends Node

@export var target: CanvasItem
@export var bounds: Rect2

func _process(delta: float) -> void:
	get_parent().position = QuarkUtils.clamp_rect(bounds, target.global_position)
