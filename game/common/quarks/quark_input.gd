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

static func four_dir_movement() -> Vector2:
	return Vector2(-1, 0)*Input.get_action_strength("ui_left") \
		 + Vector2(1, 0)*Input.get_action_strength("ui_right") \
		 + Vector2(0, -1)*Input.get_action_strength("ui_up") \
		 + Vector2(0, 1)*Input.get_action_strength("ui_down")

static func left_right_movement() -> Vector2:
	return Vector2(-1, 0)*Input.get_action_strength("ui_left") \
		 + Vector2(1, 0)*Input.get_action_strength("ui_right")

static func jump() -> float:
	return Input.get_action_strength("ui_jump")

static func four_dir_vectors() -> Array[Vector2i]:
	return [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

static func is_click(event: InputEvent) -> bool:
	return event is InputEventMouseButton and event.button_index==1 and event.pressed==true

static func is_right_click(event: InputEvent) -> bool:
	return event is InputEventMouseButton and event.button_index==2 and event.pressed==true
	
static func is_click_or_drag(event: InputEvent) -> bool:
	return (event is InputEventMouseMotion and event.button_mask == 1) or is_click(event)

static func is_keypress(event: InputEvent, key: String) -> bool:
	return event is InputEventKey and event.pressed==true and event.echo==false and event.keycode == key.to_upper().unicode_at(0)
