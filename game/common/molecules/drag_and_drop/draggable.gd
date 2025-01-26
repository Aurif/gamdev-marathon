extends Node
class_name MolDragAndDrop_Draggable

@export var n_hitbox: Area2D
@export var n_transitions: AtomEffectTransition
@export var current_area: MolDragAndDrop_DropArea

var is_dragging: bool = false
var target_area: MolDragAndDrop_DropArea
var _position_delta: Vector2
var _snapback_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	n_hitbox.mouse_entered.connect(_on_mouse_entered)
	n_hitbox.mouse_exited.connect(_on_mouse_exited)
	n_hitbox.input_event.connect(_on_area_input)
	$Area2D.area_entered.connect(_on_area_entered)
	$Area2D.area_exited.connect(_on_area_exited)

##
## Dragged element
##
func _on_mouse_entered() -> void:
	n_transitions.set_scale(0.9, 0.2)

func _on_mouse_exited() -> void:
	n_transitions.set_scale(1, 0.2)

func _on_area_input(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		start_dragging()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and is_dragging:
		n_transitions.target().global_position = event.position + _position_delta
	if event is InputEventMouseButton and event.button_index == 1 and not event.pressed:
		stop_dragging()

func start_dragging() -> void:
	is_dragging = true
	n_transitions.set_scale(0.8, 0.2)
	_position_delta = n_transitions.target().global_position - get_viewport().get_mouse_position()
	_snapback_position = n_transitions.target().global_position
	$Area2D.set_global_position(get_viewport().get_mouse_position())
	n_transitions.set_z_index(2)

func stop_dragging() -> void:
	if not is_dragging:
		return
	is_dragging = false
	n_transitions.set_z_index(0)
	n_transitions.set_scale(0.9, 0.2)
	if target_area and target_area.drop_here(self):
		return
	n_transitions.set_global_position(_snapback_position, 0.5, Tween.TRANS_ELASTIC)

##
## Dropped-in element
##
func _on_area_entered(area: Area2D) -> void:
	if not is_dragging:
		return
	if area is not MolDragAndDrop_DropArea or area == current_area:
		return
	set_target(area)

func _on_area_exited(area: Area2D) -> void:
	if area != target_area:
		return
	for ar in $Area2D.get_overlapping_areas():
		if ar is MolDragAndDrop_DropArea and ar != current_area:
			set_target(ar)
			return
	set_target(null)
	
func set_target(area: MolDragAndDrop_DropArea) -> void:
	if target_area:
		target_area.unset_highlighted()
	target_area = area
	if target_area:
		target_area.set_highlighted()
