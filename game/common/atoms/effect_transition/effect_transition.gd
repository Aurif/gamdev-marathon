extends Node
class_name AtomEffectTransition

@export var n_highlight: Node
@export var n_scale_target: Node

var _original_scale: Vector2
var _original_z_index: int
var _original_highlight_color: Color
var _original_color: Color

var _tween_scale: Tween
var _tween_position: Tween
var _tween_highlight: Tween
var _tween_modulate: Tween

func _ready() -> void:
	_original_scale = target().scale
	_original_z_index = target().z_index
	_original_color = target().modulate
	if n_highlight:
		n_highlight.visible = true
		_original_highlight_color = n_highlight.modulate
		n_highlight.modulate = Color.TRANSPARENT
	if not n_scale_target:
		n_scale_target = target()

func target() -> Node2D:
	return get_parent()

func set_scale(new_scale: float, time: float) -> void:
	if _tween_scale:
		_tween_scale.kill()
	_tween_scale = get_tree().create_tween().bind_node(self)
	_tween_scale.tween_property(n_scale_target, "scale", _original_scale*new_scale, time).set_trans(Tween.TRANS_SINE)

func set_z_index(new_z_index: int) -> void:
	target().z_index = _original_z_index + new_z_index

func set_global_position(new_position: Vector2, time: float, trans: Tween.TransitionType = Tween.TRANS_SINE, ease: Tween.EaseType = Tween.EASE_OUT) -> void:
	if _tween_position:
		_tween_position.kill()
	_tween_position = get_tree().create_tween().bind_node(self)
	_tween_position.tween_property(target(), "global_position", new_position, time).set_trans(trans).set_ease(ease)

func set_highlight(highlight: float, time: float) -> void:
	if not is_inside_tree():
		return
	if _tween_highlight:
		_tween_highlight.kill()
	_tween_highlight = get_tree().create_tween().bind_node(self)
	_tween_highlight.tween_property(n_highlight, "modulate", lerp(Color(_original_highlight_color, 0), _original_highlight_color, highlight), time).set_trans(Tween.TRANS_SINE)

func set_modulate(color: Color, time: float) -> void:
	if _tween_modulate:
		_tween_modulate.kill()
	_tween_modulate = get_tree().create_tween().bind_node(self)
	_tween_modulate.tween_property(target(), "modulate", color, time).set_trans(Tween.TRANS_SINE)

func flash_modulate(color: Color, time: float) -> void:
	if _tween_modulate:
		_tween_modulate.kill()
	_tween_modulate = get_tree().create_tween().bind_node(self)
	target().modulate = color
	_tween_modulate.tween_property(target(), "modulate", Color(color, 0), time).set_trans(Tween.TRANS_SINE)
