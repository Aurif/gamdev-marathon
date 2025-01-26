extends CharacterBody2D

@export var dir: Vector2 = Vector2.ZERO
@export var speed: float = 1200.0
@export var gravity: Vector2 = Vector2(100.0, 1000.0)

func _ready() -> void:
	velocity = dir * speed
	
	
##
## Movement
##
func _physics_process(delta: float) -> void:
	velocity += gravity * delta
	
	var collision = move_and_collide(velocity * delta)
	if not collision: return

	velocity = velocity.bounce(collision.get_normal()) * 0.6

##
## Input
##
var _mouse_start_pos: Vector2
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		var screen_rect = get_viewport().get_visible_rect()
		if not screen_rect.has_point(event.position):
			return
		_mouse_start_pos = event.position
	if event is InputEventMouseButton and event.button_index == 1 and not event.pressed and _mouse_start_pos:
		if velocity.length() > 20:
			return
		var screen_rect = get_viewport().get_visible_rect()
		var end_pos = event.position.clamp(screen_rect.position, screen_rect.end)
		var delta = end_pos-_mouse_start_pos
		velocity -= delta.normalized()*(pow(delta.length(), 3.0/4.0)*25)
