extends TextureRect

@export var dir: Vector2
@export var speed: float

var animation_tween: Tween
const MARGIN = 3

func _ready() -> void:
	_on_size_changed()
	get_parent().get_viewport().size_changed.connect(_on_size_changed)
	
	animation_tween = get_tree().create_tween().bind_node(self)
	animation_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	animation_tween.tween_callback(func(): self.position = -dir*texture.get_size()*scale*MARGIN)
	animation_tween.tween_property(self, "position", Vector2.ZERO, speed*MARGIN)
	animation_tween.set_loops()

func _on_size_changed() -> void:
	self.size = get_viewport().get_visible_rect().size/scale+dir*texture.get_size()*MARGIN
