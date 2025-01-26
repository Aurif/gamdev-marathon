extends Node


func _ready() -> void:
	if get_parent() is CollisionShape2D and get_parent().shape is RectangleShape2D:
		_set_size_rect_shape(get_parent().get_parent().get_parent().size)


func _set_size_rect_shape(size: Vector2) -> void:
	get_parent().shape.size = size
	get_parent().position = size/2
