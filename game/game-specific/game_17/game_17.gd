extends Node

@export var n_tilemap: MolDrawableTilemap
@export var n_palette: Control
@export var preset_color_button: PackedScene
@export var preset_color_rule: PackedScene

var current_level: Dictionary

signal NextLevel()

func load_level_proxy() -> void:
	load_level(n_tilemap)

func load_level(tilemap: MolDrawableTilemap) -> void:
	const DEFAULT_CELL = 4
	
	current_level = extract_row_columns(tilemap)
	
	var min_x = 0
	var min_y = 0
	var max_x = 0
	var max_y = 0
	var colors = {}
	for t in tilemap.get_used_cells():
		min_x = min(min_x, t.x)
		min_y = min(min_y, t.y)
		max_x = max(max_x, t.x)
		max_y = max(max_y, t.y)
		
		colors[tilemap.get_cell_alternative_tile(t)] = tilemap.get_cell_tile_data(t).modulate
		tilemap.set_cell(t, 0, Vector2i(0, 0), DEFAULT_CELL)
	
	var colors_parsed = [[Color("#151019"), DEFAULT_CELL]]
	for c in colors:
		colors_parsed.append([colors[c], c])
	set_colors(colors_parsed, tilemap)
	tilemap.set_current_brush_tile(Vector2i.ZERO, DEFAULT_CELL)
	tilemap.allowed_rect = Rect2i(min_x, min_y, max_x-min_x+1, max_y-min_y+1)
	
	
	var containers = {}
	var tile_size = tilemap.to_global(tilemap.map_to_local(Vector2i(1, 1)))-tilemap.to_global(tilemap.map_to_local(Vector2(0, 0)))
	for x in range(min_x, max_x+1):
		var pos_start = tilemap.to_global(tilemap.map_to_local(Vector2i(x, min_y)))-tile_size/2
		var node = VBoxContainer.new()
		get_parent().add_child(node)
		node.global_position = Vector2(pos_start.x, 0)
		node.size = Vector2(tile_size.x, pos_start.y-16)
		node.alignment = BoxContainer.ALIGNMENT_END
		containers[["column", x]] = node
	
	for y in range(min_y, max_y+1):
		var pos_start = tilemap.to_global(tilemap.map_to_local(Vector2i(min_x, y)))-tile_size/2
		var node = HBoxContainer.new()
		get_parent().add_child(node)
		node.global_position = Vector2(0, pos_start.y)
		node.size = Vector2(pos_start.x-16, tile_size.y)
		node.alignment = BoxContainer.ALIGNMENT_END
		containers[["row", y]] = node
		
	for k in current_level:
		var parent = containers[[k[0], k[1]]] as Control
		var node = preset_color_rule.instantiate() as BoxContainer
		node.get_node("Label").text = str(current_level[k])
		node.modulate = k[2]
		if k[0] == "row":
			node.vertical = true
		parent.add_child(node)

func set_colors(colors, tilemap: MolDrawableTilemap) -> void:
	for c in colors:
		var node = preset_color_button.instantiate()
		node.get_node("ButtonOcto").get_node("Polygon2D").color = c[0]
		node.get_node("ButtonOcto").get_node("Clickable").onClick.connect(
			tilemap.set_current_brush_tile.bind(Vector2i.ZERO, c[1]).unbind(1)
		)
		n_palette.add_child(node)

func extract_row_columns(tilemap: MolDrawableTilemap) -> Dictionary:
	var result = {}
	for t in tilemap.get_used_cells():
		var color = tilemap.get_cell_tile_data(t).modulate
		var key_column = ["column", t.x, color]
		var key_row = ["row", t.y, color]
		
		result[key_column] = result.get(key_column, 0) + 1
		result[key_row] = result.get(key_row, 0) + 1
		
	return result

func check_win(tilemap: MolDrawableTilemap) -> void:
	var current_state = extract_row_columns(tilemap)
	if current_state == current_level:
		current_level = { "block_checks": true}
		NextLevel.emit()
