extends Node

@export var hide_cursor: bool = true
@export var use_position: bool = true
@export var use_physics: bool = false
@export var use_force: bool = false

func _ready() -> void:
	if hide_cursor:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_parent().position = get_viewport().get_mouse_position()

func _input(event: InputEvent) -> void:
	if use_position and event is InputEventMouseMotion:
		get_parent().position = event.position

func _physics_process(delta: float) -> void:
	if use_physics:
		get_parent().move_and_collide(get_viewport().get_mouse_position()-get_parent().global_position)
	
	if use_force:
		get_parent().apply_force((get_viewport().get_mouse_position()-get_parent().global_position)*delta*100000)
