extends Node

@export var n_hitbox: Area2D
@export var n_transitions: AtomEffectTransition

var is_dragging: bool = false
var position_tween: Tween
var scale_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	n_hitbox.mouse_entered.connect(_on_mouse_entered)
	n_hitbox.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	n_transitions.set_scale(0.9, 0.2)

func _on_mouse_exited() -> void:
	n_transitions.set_scale(1, 0.2)
