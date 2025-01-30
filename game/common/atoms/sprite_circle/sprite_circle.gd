@tool
extends CanvasItem

@export var radius: int = 32
@export var filled: bool = true

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if filled:
		draw_circle(_get_center(), radius, Color.WHITE)
	else:
		draw_circle(_get_center(), radius, Color.WHITE, false, 2)

func _get_center() -> Vector2:
	if 'size' not in self:
		return Vector2.ZERO
	return self.size/2
