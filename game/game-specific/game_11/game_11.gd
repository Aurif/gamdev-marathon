extends Node

@export var sprite_candidates: Array[CompressedTexture2D] = []
@export var preset_tile: PackedScene
@export var n_label: Label
@export var n_timer: MolTimer
@export var n_win_screen: MolWinScreen

var score: int = 0
var difficulty: int = 1
var valid_positions = []
var in_game: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(-8, 9):
		for y in range(-4, 5):
			valid_positions.append(Vector2(x, y)*67+Vector2(0, 10))
			
	show_preview.call_deferred()

func show_preview() -> void:
	clear_tiles()
	sprite_candidates.shuffle()
	var node = preset_tile.instantiate()
	node.position = Vector2.ZERO
	node.get_node("Sprite2D").texture = sprite_candidates[0]
	$SpawnHere.add_child(node)
	node.get_node("Clickable").onClick.connect(show_tiles.unbind(1))
	
func show_tiles() -> void:
	if not in_game:
		in_game = true
		n_timer.start_timer(90*1000, end_game)
	
	$SoundClick.play()
	clear_tiles()
	valid_positions.shuffle()
	var tiles_to_show = min(len(valid_positions), len(sprite_candidates), difficulty)
	for i in range(tiles_to_show):
		var node = preset_tile.instantiate()
		node.position = valid_positions[i]
		node.get_node("Sprite2D").texture = sprite_candidates[i]
		$SpawnHere.add_child(node)
		if i == 0:
			node.get_node("Clickable").onClick.connect(score_good.unbind(1))
		else:
			node.get_node("Clickable").onClick.connect(score_bad.unbind(1))

func clear_tiles() -> void:
	for child in $SpawnHere.get_children():
		child.queue_free()

func score_good() -> void:
	$SoundGood.play()
	score += 1
	n_label.text = str(score)
	difficulty += 1
	show_preview()

func score_bad() -> void:
	$SoundBad.play()
	score -= 1
	n_label.text = str(score)
	show_preview()

func end_game() -> void:
	n_win_screen.show_screen("Your score: "+str(score))
