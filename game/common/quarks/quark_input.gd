class_name QuarkInput

static func four_dir_movement_discrete() -> Vector2i:
	var left = Input.get_action_strength("ui_left") > 0.2
	var right = Input.get_action_strength("ui_right") > 0.2
	var up = Input.get_action_strength("ui_up") > 0.2
	var down = Input.get_action_strength("ui_down") > 0.2
	
	if int(left) + int(right) + int(up) + int(down) > 1:
		return Vector2i(0, 0)
	if left:
		return Vector2i(-1, 0)
	if right:
		return Vector2i(1, 0)
	if up:
		return Vector2i(0, -1)
	if down:
		return Vector2i(0, 1)
	return Vector2i(0, 0)

static func four_dir_vectors() -> Array[Vector2i]:
	return [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
