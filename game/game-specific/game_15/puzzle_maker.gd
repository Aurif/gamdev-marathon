extends Node

@export var image: CompressedTexture2D
@export var splits: Vector2i
@export var subsets: int
@export var n_image_bg: MolBackgroundBlurred
@export var n_image_bg_holder: Control
@export var preset_drop_area: PackedScene
@export var preset_puzzle_piece: PackedScene
@export var n_label_correct: Label
@export var n_label_incorrect: Label

var finished = false
var current_image: Image
var current_image_blurred: Image
var current_subset = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_image.call_deferred(image, splits)

var holder_to_pos = {}
var piece_to_pos = {}
var piece_subsets = []

func spawn_image(img: CompressedTexture2D, splits: Vector2i) -> void:
	var split_size = Vector2(Vector2i(img.get_size()/2/Vector2(splits)))
	n_image_bg_holder.set_custom_minimum_size(img.get_size()/2)
	
	current_image = img.get_image()
	current_image_blurred = Image.new()
	current_image_blurred.copy_from(current_image)
	current_image_blurred.resize(splits.x, splits.y, Image.INTERPOLATE_LANCZOS)
	current_image_blurred.resize(split_size.x*splits.x*2, split_size.y*splits.y*2, Image.INTERPOLATE_NEAREST)
	n_image_bg.set_img(current_image)
	
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
			var sprite2D = sprite.get_node("Sprite2D") as Sprite2D
			sprite2D.region_rect = Rect2(
				split_size*2*Vector2(x, y),
				split_size*2
			)
			sprite2D.texture = ImageTexture.create_from_image(current_image_blurred)
			
	pieces.shuffle()
	var pos = 0
	for i in range(subsets-1):
		var subset = []
		for j in range(splits.x*splits.y/subsets):
			subset.append(pieces[pos])
			pos += 1
		piece_subsets.append(subset)
	
	var subset = []
	for p in range(pos, len(pieces)):
		subset.append(pieces[p])
	piece_subsets.append(subset)
	next_subset()
	
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
			
	for subset in piece_subsets:
		for piece in subset:
			(piece.get_node("EffectTransition").n_scale_target.get_node("Sprite2D") as Sprite2D).texture = ImageTexture.create_from_image(current_image)
			
	finished = true
	if is_puzzle_valid:
		n_label_correct.visible = true
	else:
		n_label_incorrect.visible = true

func next_subset() -> void:
	if finished:
		return
	if current_subset >= 0:
		for piece in piece_subsets[current_subset]:
			(piece.get_node("EffectTransition").n_scale_target.get_node("Sprite2D") as Sprite2D).texture = ImageTexture.create_from_image(current_image_blurred)
			
	current_subset = (current_subset + 1)%subsets
	for piece in piece_subsets[current_subset]:
		(piece.get_node("EffectTransition").n_scale_target.get_node("Sprite2D") as Sprite2D).texture = ImageTexture.create_from_image(current_image)
