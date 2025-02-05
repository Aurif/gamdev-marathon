extends Node

@export var visible_size: Vector2 = Vector2(56, 56)

func _physics_process(delta: float) -> void:
	var viewport = get_viewport().get_visible_rect().size
	
	if get_parent().global_position.y < 0 - visible_size.y/2:
		get_parent().global_position.y += viewport.y + visible_size.y
	if get_parent().global_position.y > viewport.y + visible_size.y/2:
		get_parent().global_position.y -= viewport.y + visible_size.y
	if get_parent().global_position.x < 0 - visible_size.x/2:
		get_parent().global_position.x += viewport.x + visible_size.x
	if get_parent().global_position.x > viewport.x + visible_size.x/2:
		get_parent().global_position.x -= viewport.x + visible_size.x
