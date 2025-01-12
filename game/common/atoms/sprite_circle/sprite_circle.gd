@tool
extends Node2D

@export var radius: int = 32
@export var filled: bool = true

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if filled:
		draw_circle(Vector2.ZERO, radius, Color.WHITE)
	else:
		draw_circle(Vector2.ZERO, radius, Color.WHITE, false, 2)
