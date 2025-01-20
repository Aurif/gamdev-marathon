extends Node2D
class_name G10Item

@export var speed = 400
var rotate_speed = 0
func _ready() -> void:
	rotate_speed = randf_range(-2*PI, 2*PI)

func _process(delta: float) -> void:
	speed += delta*sqrt(speed)
	self.position += Vector2(0, 1)*delta*speed
	self.rotation += rotate_speed*delta
	if self.position.y > get_viewport().get_viewport().size.y + 300:
		queue_free()
