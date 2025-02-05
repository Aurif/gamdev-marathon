extends Node

@export var show_on_hover: Node
@export var resize_on_click: bool = true
@export var click_sound: bool = true

@export var n_area: CollisionObject2D

signal onClick()

var show_on_hover_tween

func _triggering_node() -> Node:
	if n_area:
		return n_area
	return get_parent()

func _ready() -> void:
	var triggering_node = _triggering_node()
	triggering_node.mouse_entered.connect(_mouse_entered)
	triggering_node.mouse_exited.connect(_mouse_exited)
	if triggering_node.get("input_event"):
		triggering_node.input_event.connect(_input_event)
	if triggering_node.get("gui_input"):
		triggering_node.gui_input.connect(_gui_input)
	
	if show_on_hover:
		show_on_hover.modulate = Color("#ffffff", 0)

func __on_mouse_click():
	if click_sound:
		$SoundClick.play()
	if resize_on_click:
		if get_parent().get("size"):
			get_parent().pivot_offset = get_parent().size/2
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_property(get_parent(), "scale", Vector2(0.8, 0.8), 0.1).set_trans(Tween.TRANS_SINE)
		tween.tween_property(get_parent(), "scale", Vector2(1, 1), 0.1).set_trans(Tween.TRANS_SINE)
	onClick.emit()

func _mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	if show_on_hover:
		if show_on_hover_tween:
			show_on_hover_tween.kill()
		show_on_hover_tween = get_tree().create_tween().bind_node(self)
		show_on_hover_tween.tween_property(show_on_hover, "modulate", Color("#ffffff", 1), 0.2).set_trans(Tween.TRANS_SINE)
	
func _mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if show_on_hover:
		if show_on_hover_tween:
			show_on_hover_tween.kill()
		if not get_tree():
			return
		show_on_hover_tween = get_tree().create_tween().bind_node(self)
		show_on_hover_tween.tween_property(show_on_hover, "modulate", Color("#ffffff", 0), 0.2).set_trans(Tween.TRANS_SINE)

func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		__on_mouse_click()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		__on_mouse_click()
