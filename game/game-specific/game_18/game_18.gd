extends Node

@export var n_texture: TextureRect
@export var n_paint_label: Label
@export var n_instructions_label: Label
@export var n_victory_screen: MolWinScreen
@export var n_canvas: MolDrawableCanvas
var center

func _ready() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	center = Vector2(
		randi_range(0.05*viewport_size.x, 0.95*viewport_size.x),
		randi_range(0.1*viewport_size.y, 0.9*viewport_size.y)
	)
	n_texture.size = viewport_size*2
	n_texture.position = center-viewport_size

func _update_paint(paint_used: int) -> void:
	n_paint_label.text = "Used "+str(paint_used)+"ml of paint"
	n_instructions_label.visible = false

func _input(event: InputEvent) -> void:
	if QuarkInput.is_click_or_drag(event) and center.distance_to(event.position) < 12:
		n_victory_screen.show_screen("Used "+str(n_canvas.paint_used)+"ml of paint")
