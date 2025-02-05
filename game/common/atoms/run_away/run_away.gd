extends Node

func _physics_process(delta: float) -> void:
	var viewport = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	var multi_mouse_pos = [
		mouse_pos,
		mouse_pos + Vector2(viewport.x, 0),
		mouse_pos - Vector2(viewport.x, 0),
		mouse_pos + Vector2(0, viewport.y),
		mouse_pos - Vector2(0, viewport.y)
	]
	
	for pos in multi_mouse_pos:
		var dist: Vector2 = get_parent().global_position - pos
		if dist.length() < 200:
			do_movement(get_speed_vector(angle_smoothed(dist)))

func angle_smoothed(v: Vector2) -> Vector2:
	var ang = rad_to_deg(v.angle())
	const ANGLE_SMOOTHING = 3
	
	for a in [90, 270]:
		if ang > a-ANGLE_SMOOTHING and ang < a+ANGLE_SMOOTHING:
			v.x = 0
	for a in [0, 180]:
		if ang > a-ANGLE_SMOOTHING and ang < a+ANGLE_SMOOTHING:
			v.y = 0
	return v
	
func get_speed_vector(dist: Vector2) -> Vector2:
	return dist.normalized()*min(3000, 1000000/pow(dist.length()+1, 1.8))

func do_movement(v: Vector2) -> void:
	if get_parent() is CharacterBody2D:
		get_parent().velocity = v
		get_parent().move_and_slide()
	
	if get_parent() is RigidBody2D:
		(get_parent() as RigidBody2D).apply_force(v*max(get_parent().linear_damp/10, 1))
