extends Node

@export var min_scale: Vector2
var tween: Tween

func _ready() -> void:
	next_anim()

func next_anim() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", lerp(Vector2(1, 1), min_scale, 0.5+0.5*randf()), randf_range(3, 5.5))
	tween.tween_property(self, "scale", Vector2(1, 1), randf_range(3, 5.5))
	tween.tween_callback(next_anim)
