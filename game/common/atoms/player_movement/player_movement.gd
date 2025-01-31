extends Node

@export var speed = 200

func _physics_process(delta: float) -> void:
	get_parent().velocity = QuarkInput.four_dir_movement()*speed
	get_parent().move_and_slide()
