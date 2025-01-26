extends CharacterBody2D

@export var gravity: Vector2 = Vector2(100.0, 1000.0)
@export var n_trajectory: MolThrowWithTrajectory_Trajectory

func enable() -> void:
	self.process_mode = Node.PROCESS_MODE_INHERIT

##
## Movement
##
func _physics_process(delta: float) -> void:
	velocity += gravity * delta
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal()) * 0.6
	
	if velocity.length() > 20 and aiming:
		n_trajectory.update_trajectory(_calc_throw_velocity(get_viewport().get_mouse_position()), gravity)
		n_trajectory.modulate = Color("#754647")
	else:
		n_trajectory.modulate = Color("#766650")

##
## Input
##
var aiming: bool = false
var _mouse_start_pos: Vector2
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		var screen_rect = get_viewport().get_visible_rect()
		if not screen_rect.has_point(event.position):
			return
		aiming = true
		_mouse_start_pos = event.position
	if event is InputEventMouseButton and event.button_index == 1 and not event.pressed and _mouse_start_pos:
		aiming = false
		n_trajectory.clear_points()
		if velocity.length() > 20:
			return
		velocity += _calc_throw_velocity(event.position)
	if event is InputEventMouseMotion and aiming:
		n_trajectory.update_trajectory(_calc_throw_velocity(event.position), gravity)

func _calc_throw_velocity(end_pos: Vector2) -> Vector2:
	var screen_rect = get_viewport().get_visible_rect()
	end_pos = end_pos.clamp(screen_rect.position, screen_rect.end)
	var delta = end_pos-_mouse_start_pos
	return -delta.normalized()*(pow(delta.length(), 3.0/4.0)*25)/2
	
