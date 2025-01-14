extends Node

@export var speed: int = 50
@export var angle_offset: int = 0

func _physics_process(delta: float) -> void:
	get_parent().position += Vector2(0, -speed*5*delta).rotated(get_parent().rotation + deg_to_rad(angle_offset))

func _on_screen_exited() -> void:
	get_parent().queue_free()
