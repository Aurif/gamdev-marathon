extends Node
class_name AtomEffectTransition

var _original_scale: Vector2

var _tween_scale: Tween

func _ready() -> void:
	_original_scale = get_parent().scale

func set_scale(new_scale: float, time: float) -> void:
	if _tween_scale:
		_tween_scale.kill()
	_tween_scale = get_tree().create_tween().bind_node(self)
	_tween_scale.tween_property(get_parent(), "scale", _original_scale*new_scale, time).set_trans(Tween.TRANS_SINE)
