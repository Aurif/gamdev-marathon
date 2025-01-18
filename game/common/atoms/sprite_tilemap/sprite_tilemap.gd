extends TileMapLayer

func _ready() -> void:
	var terrain_map = {}
	for t in range(tile_set.get_terrains_count(0)):
		terrain_map[tile_set.get_terrain_name(0, t)] = t
	
	for tile in get_used_cells():
		var data = get_cell_tile_data(tile)
		if not data:
			continue
		var overwrite_with = data.get_custom_data("OverwriteWithTerrain")
		if overwrite_with:
			set_cells_terrain_connect([tile], 0, terrain_map[overwrite_with])
