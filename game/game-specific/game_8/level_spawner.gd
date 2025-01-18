extends TileMapLayer
class_name G8LevelSpawner

@export var preset_tile: PackedScene
@export var tile_size: Vector2 = Vector2(80, 80)

var side = {}
var nodes = {}
var blob_free_sides = []

signal LevelWon

func spawn() -> void:
	side = {}
	nodes = {}
	blob_free_sides = []
	
	for tile in self.get_used_cells():
		side[tile] = []
		for dir in QuarkInput.four_dir_vectors():
			if self.get_cell_source_id(tile+dir*2) == -1:
				continue
			side[tile].append(dir)
		
		spawn_tile(tile)
	
	var initial_merge_order = side.keys()
	initial_merge_order.shuffle()
	initial_merge_order.sort_custom(func(a, b): return len(side[a]) > len(side[b]))
	
	add_to_blob(initial_merge_order[0])
	for i in range(1, len(initial_merge_order)):
		connect_to_blob(initial_merge_order[i])
		
	while len(blob_free_sides) > 0:
		var s1 = blob_free_sides.pick_random()
		blob_free_sides.erase(s1)
		var s2 = blob_free_sides.pick_random()
		blob_free_sides.erase(s2)
		
		connect_sides(s1[0], s1[1], s2[0], s2[1])
	
	self.visible = false

func spawn_tile(tile: Vector2i) -> void:
	var node = preset_tile.instantiate() as G8Tile
	nodes[tile] = node
	
	var tile_data = self.get_cell_tile_data(tile)
	if tile_data.get_custom_data("StartingPos"):
		node.in_node = true
	
	if tile_data.get_custom_data("IsFinish"):
		node.variant_goal()
		node.PlayerEntered.connect(func(): LevelWon.emit())
	
	$"..".add_child(node)
	node.global_position = self.global_position+Vector2(tile)/2*tile_size

func add_to_blob(tile: Vector2i) -> void:
	for dir in side[tile]:
		blob_free_sides.append([tile, dir])

func connect_to_blob(tile: Vector2i) -> void:
	var connect_to = blob_free_sides.pick_random()
	var connect_from = side[tile].pick_random()
	add_to_blob(tile)
	connect_sides(tile, connect_from, connect_to[0], connect_to[1])
	
func connect_sides(tile1: Vector2i, dir1: Vector2i, tile2: Vector2i, dir2: Vector2i) -> void:
	blob_free_sides.erase([tile1, dir1])
	blob_free_sides.erase([tile2, dir2])
	nodes[tile1].register_neighbour(dir1, nodes[tile2], dir2)
	nodes[tile2].register_neighbour(dir2, nodes[tile1], dir1)
