extends Node
class_name AtomInputMouseRotation

@export var center: Vector2
@export var offset_angle: int
@export var distance: int
@export var offset_x: int = 0
@export var offset_y: int = 0
@export var step: int = 0

@export var update_position: bool = true

var mouse_pos: Vector2

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position

func _process(_delta: float) -> void:
	var rotation_center = Vector2(get_viewport().get_visible_rect().size) * center + Vector2(offset_x, offset_y)
	var rotation_angle = (mouse_pos - rotation_center).angle() + deg_to_rad(offset_angle)
	if step != 0:
		rotation_angle = round(rotation_angle/deg_to_rad(step))*deg_to_rad(step)
	get_parent().rotation = rotation_angle
	if update_position:
		get_parent().position = rotation_center + Vector2(0, -distance).rotated(rotation_angle)
	
		$SpriteCenter.position = rotation_center
		$SpriteRadius.position = rotation_center
	$SpriteRadius.radius = distance

func reset_offset_to_now() -> void:
	mouse_pos = get_viewport().get_mouse_position()
	var rotation_center = Vector2(get_viewport().get_visible_rect().size) * center + Vector2(offset_x, offset_y)
	var rotation_angle = (mouse_pos - rotation_center).angle()
	
	offset_angle = rad_to_deg(get_parent().rotation-rotation_angle)
	
