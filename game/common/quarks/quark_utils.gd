class_name QuarkUtils

static func clamp_rect(rect: Rect2, pos: Vector2) -> Vector2:
	return Vector2(
		clamp(pos.x, min(rect.position.x, rect.end.x), max(rect.position.x, rect.end.x)),
		clamp(pos.y, min(rect.position.y, rect.end.y), max(rect.position.y, rect.end.y))
	)
