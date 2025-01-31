extends Node

@export var interval: float = 0.05
@export var max_points: int = 200

var last_pos: Vector2

func _ready() -> void:
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_interval(interval)
	tween.tween_callback(_add_point)
	tween.set_loops()


func _add_point() -> void:
	if last_pos == get_parent().global_position:
		return
	last_pos = get_parent().global_position
	$Line2D.add_point(get_parent().global_position, 0)
	if $Line2D.get_point_count() > max_points:
		$Line2D.remove_point($Line2D.get_point_count()-1)
