extends CharacterBody2D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _physics_process(delta: float) -> void:
	_move_to_pos(get_viewport().get_mouse_position(), delta)

func _move_to_pos(pos: Vector2, delta: float) -> void:
	var collided_with = []
	while pos != global_position:
		var collision = move_and_collide(pos-global_position)
		if not collision:
			break
		
		var collider = collision.get_collider()
		collided_with.append([
			collider,
			collider.global_position-global_position
		])
		add_collision_exception_with(collision.get_collider())
		
	for collision in collided_with:
		remove_collision_exception_with(collision[0])
		var new_pos = global_position+collision[1]
		var new_velocity = (new_pos - collision[0].global_position)/delta
		collision[0].set_speed(max(new_velocity.length(), collision[0].speed))
		collision[0].set_direction(new_velocity)
		collision[0].global_position = new_pos
