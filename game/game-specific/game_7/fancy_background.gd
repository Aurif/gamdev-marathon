extends Node
class_name G7FancyBackground

@export var base_size: Vector2i = Vector2i(22, 12)
@export var layers: int = 100
@export var transition_type: Tween.TransitionType
@export var ease_type: Tween.EaseType
@export var starting_scale: float = 0.8
@export var min_scale: float = 0.35

@export var dim_color: Color
@export var starting_dim: float = 0.24
@export var min_dim: float = 0.07

@export var preset_bg_layer: PackedScene

func _ready() -> void:
	generate_background.call_deferred()

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
		layer.generation_size = Vector2i(ceil(Vector2(base_size)/scale))+Vector2i(2, 1)
		layer.position = Vector2(-18, -18)*scale
		
		var dim_level = Tween.interpolate_value(
			starting_dim, 
			min_dim-starting_dim,
			float(i)/layers, 1,
			transition_type, ease_type
		)
		layer.modulate = lerp(dim_color, Color.WHITE, dim_level)
		
		add_child(layer)
		move_child(layer, 0)
		layer.generate()

func transition_out() -> void:
	for i in range(layers):
		var t = lerp(1.0, 0.0, float(i)/layers)
		var layer = self.get_child(-i)
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_interval(t)
		tween.tween_property(layer, "modulate", Color(layer.modulate, 0), 0.2)
		tween.tween_callback(layer.queue_free)

func transition_in() -> void:
	generate_background()
	
	for i in range(layers):
		var t = lerp(1.0, 0.0, float(i+1)/layers)
		var layer = self.get_child(-i)
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_interval(t)
		var target_modulate = layer.modulate
		layer.modulate = Color(layer.modulate, 0)
		tween.tween_property(layer, "modulate", target_modulate, 0.1)
