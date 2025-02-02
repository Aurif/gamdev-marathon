extends Node
class_name MolGrid

@export var tiles: Vector2i
@export var tile_size: Vector2
@export var preset: PackedScene

var nodes = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_make_grid.call_deferred()

func _make_grid() -> void:
	for y in tiles.y:
		for x in tiles.x:
			var tile = preset.instantiate()
			add_child(tile)
			tile.position = tile_size*Vector2(x, y)-round(tile_size*Vector2(tiles-Vector2i(1, 1))/2)
			nodes.append(tile)
