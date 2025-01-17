extends Node

@export var base_size: Vector2i = Vector2i(22, 12)
@export var layers: int = 100
@export var transition_type: Tween.TransitionType
@export var ease_type: Tween.EaseType
@export var starting_scale: float = 0.7
@export var min_scale: float = 0.3

@export var dim_color: Color
@export var starting_dim: float = 0.24
@export var min_dim: float = 0.07

@export var preset_bg_layer: PackedScene

func _ready() -> void:
	generate_background()

func generate_background() -> void:
	for i in range(layers):
		var layer = preset_bg_layer.instantiate() as G7BgLayer
		var scale = Tween.interpolate_value(
			starting_scale, 
			min_scale-starting_scale,
			float(i)/layers, 1,
			transition_type, ease_type
		)
		layer.scale *= scale
		layer.generation_size = ceil(Vector2(base_size)/scale)
		
		var dim_level = Tween.interpolate_value(
			starting_dim, 
			min_dim-starting_dim,
			float(i)/layers, 1,
			transition_type, ease_type
		)
		layer.modulate = lerp(dim_color, Color.WHITE, dim_level)
		
		add_child.call_deferred(layer)
		move_child.call_deferred(layer, 0)
		layer.generate()
