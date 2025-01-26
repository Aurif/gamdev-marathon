extends Node

@export var image: CompressedTexture2D
@export var splits: Vector2i
@export var n_image_bg: MolBackgroundBlurred
@export var n_image_bg_holder: Control
@export var preset_drop_area: PackedScene
@export var preset_puzzle_piece: PackedScene
@export var n_label_correct: Label
@export var n_label_incorrect: Label

var finished = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_image.call_deferred(image, splits)

var holder_to_pos = {}
var piece_to_pos = {}

func spawn_image(img: CompressedTexture2D, splits: Vector2i) -> void:
	n_image_bg.set_img(img.get_image())
	var split_size = Vector2(Vector2i(img.get_size()/2/Vector2(splits)))
	n_image_bg_holder.set_custom_minimum_size(img.get_size()/2)
	
	var holders = []
	var pieces = []
	
	var outside_pos = Vector2(get_viewport().get_visible_rect().size.x/2-split_size.x/2, -split_size.y)
	for x in range(splits.x):
		for y in range(splits.y):
			var node = preset_drop_area.instantiate()
			n_image_bg_holder.add_child(node)
			node.position = split_size*Vector2(x+0.5, y+0.5)
			node.scale = split_size/Vector2(40, 40)
			holders.append(node)
			holder_to_pos[node] = Vector2i(x, y)
			
			var puzzle_piece = preset_puzzle_piece.instantiate() as Control
			n_image_bg_holder.add_child(puzzle_piece)
			puzzle_piece.global_position = Vector2(-1000, -1000)
			puzzle_piece.size = split_size
			pieces.append(puzzle_piece)
			piece_to_pos[puzzle_piece.get_node("Draggable")] = Vector2i(x, y)
			var hitbox = puzzle_piece.get_node("Draggable").n_hitbox.get_child(0) as CollisionShape2D
			hitbox.shape.size = split_size
			hitbox.position = split_size/2
			var sprite = puzzle_piece.get_node("EffectTransition").n_scale_target
			sprite.pivot_offset = split_size/2
			(sprite.get_node("Sprite2D") as Sprite2D).region_rect = Rect2(
				split_size*2*Vector2(x, y),
				split_size*2
			)
			
	pieces.shuffle()
	var tween = get_tree().create_tween()
	tween.tween_interval(0.5)
	for p in range(len(pieces)):
		tween.tween_callback(func(): 
			pieces[p].global_position = outside_pos
			holders[p].get_node("Area2D").drop_here(pieces[p].get_node("Draggable"))
		)
		tween.tween_interval(1.0/splits.x/splits.y)

func check_puzzle() -> void:
	if finished:
		return
	var is_puzzle_valid = true
	for holder in holder_to_pos:
		if piece_to_pos[holder.get_node("Area2D").currently_holds] != holder_to_pos[holder]:
			is_puzzle_valid = false
			break
			
	finished = true
	if is_puzzle_valid:
		n_label_correct.visible = true
	else:
		n_label_incorrect.visible = true
