extends Node

@export var speed: float = 4
@export var max_distance: Vector2

var float_tween: Tween

func _ready() -> void:
	start_animation.call_deferred()

func start_animation():
	var actual_speed = speed*randf_range(0.9, 1.1)
	float_tween = get_tree().create_tween().bind_node(self)
	float_tween.set_trans(Tween.TRANS_SINE)
	float_tween.tween_property(get_parent(), "position", get_parent().position+max_distance, actual_speed)
	float_tween.tween_property(get_parent(), "position", get_parent().position, actual_speed)
	float_tween.set_loops()
	float_tween.custom_step(randf_range(0, actual_speed*2))
