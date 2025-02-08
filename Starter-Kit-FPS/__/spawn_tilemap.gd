extends Node

@export var presets: Array[PackedScene]

@onready var parent: TileMapLayer = get_parent()
@onready var spawn_here: Node = $"../../Level"
func _ready() -> void:
	fill_walls()
	spawn_tilemap()

func fill_walls() -> void:
	for t in parent.get_used_cells():
		var tilId = parent.get_cell_alternative_tile(t)
		if tilId % 2 != 0:
			continue
		for off in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
			if parent.get_cell_alternative_tile(t+off) != -1:
				continue
			parent.set_cell(t+off, 0, Vector2.ZERO, tilId+1)

func spawn_tilemap() -> void:
	for t in parent.get_used_cells():
		var node: Node3D = presets[parent.get_cell_alternative_tile(t)].instantiate()
		spawn_here.add_child(node)
		node.global_position = Vector3(t.x, node.global_position.y, t.y)
		
				
