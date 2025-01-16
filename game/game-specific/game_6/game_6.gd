extends Node

@export var size: Vector2i
@export var n_root: Control
@export var n_pattern_tilemap: TileMap
@export var n_hover_tilemap: TileMapLayer
@export var n_draw_tilemap: TileMapLayer
@export var n_label_progress: Label
@export var n_label_accuracy: Label
@export var n_wfc: WFC2DGenerator
@export var n_win_screen: MolWinScreen

var tilePosition: Vector2i
var lightSquares = 0
var progress = 0
var mistakes = 0

func _ready():
	n_wfc.rect = Rect2i(Vector2i.ZERO, size)
	n_wfc.start()

func start_game():
	for x in range(size.x*3):
		for y in range(size.y*3):
			var pattern = n_pattern_tilemap.get_cell_atlas_coords(0, Vector2i(x, y))
			if pattern == Vector2i(1, 1):
				lightSquares += 1
	update_labels()

func _mouse_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var newPosition = n_pattern_tilemap.local_to_map(n_pattern_tilemap.get_local_mouse_position())
		if newPosition.x < 0 or newPosition.y < 0 or newPosition.x >= size.x*3 or newPosition.y >= size.y*3:
			update_pos(Vector2i(-1, -1))
		else:
			update_pos(newPosition)
		
	if (event is InputEventMouseMotion and event.button_mask == 1) or (event is InputEventMouseButton and event.button_index==1 and event.pressed==true):
		draw_tile()
	
func _mouse_out() -> void:
	update_pos(Vector2i(-1, -1))
	
func update_pos(newPosition: Vector2i) -> void:
	if newPosition == tilePosition:
		return
	n_hover_tilemap.erase_cell(tilePosition)
	if newPosition != Vector2i(-1, -1):
		n_hover_tilemap.set_cell(newPosition, 0, Vector2i(1, 0))
	tilePosition = newPosition

func draw_tile() -> void:
	if tilePosition == Vector2i(-1, -1):
		return
	if n_draw_tilemap.get_cell_source_id(tilePosition) != -1:
		return
	
	var pattern = n_pattern_tilemap.get_cell_atlas_coords(0, tilePosition)
	if pattern == Vector2i(1, 1):
		# correct
		n_draw_tilemap.set_cell(tilePosition, 0, Vector2i(0, 2))
		progress += 1
	elif pattern == Vector2i(0, 1):
		# incorrect
		n_label_accuracy.get_node("Highlight").highlight()
		n_draw_tilemap.set_cell(tilePosition, 0, Vector2i(1, 2))
		mistakes += 1
	
	update_labels()

func update_labels() -> void:
	n_label_progress.text = ("Progress: %.2f" % (float(progress)/float(lightSquares)*100.0)) + "%"
	var blackSquares = size.x*size.y*9-lightSquares
	var accuracy = ("Accuracy: %.2f" % (100.0-float(mistakes)/float(blackSquares)*100.0)) + "%"
	n_label_accuracy.text = accuracy
	
	if progress >= lightSquares:
		n_win_screen.show_screen(accuracy)
