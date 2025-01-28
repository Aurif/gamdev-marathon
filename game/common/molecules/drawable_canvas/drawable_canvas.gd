extends Control
class_name MolDrawableCanvas

var next_draw: Array[Vector2] = []
var paint_used: int = 0
var _last_pos: Vector2 = Vector2(-1, -1)

signal OnPainted(paint_used: int)

func _draw() -> void:
	for c in next_draw:
		draw_circle(c, 5, Color.WHITE)
	next_draw = []

func _input(event: InputEvent) -> void:
	if QuarkInput.is_click_or_drag(event):
		var painted_once = false
		if _last_pos == Vector2(-1, -1):
			painted_once = _add_dot(event.position) or painted_once
		else:
			var distance_from_last = max(1, round(event.position.distance_to(_last_pos)/5.0))
			for i in range(distance_from_last):
				painted_once = _add_dot(lerp(event.position, _last_pos, float(i)/distance_from_last)) or painted_once
		if painted_once:
			queue_redraw()
			OnPainted.emit(paint_used)
		_last_pos = event.position
	else:
		_last_pos = Vector2(-1, -1)

func _add_dot(pos: Vector2) -> bool:
	if get_parent().get_texture().get_image().get_pixelv(pos).a > 0:
		return false
	next_draw.append(pos)
	paint_used += 1
	return true
