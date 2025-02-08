extends Node

@export var presets: Array[PackedScene]

@onready var parent: TileMapLayer = get_parent()
@onready var spawn_here: Node = $"../../Level"
func _ready() -> void:
	spawn_tilemap()

func spawn_tilemap() -> void:
	for t in parent.get_used_cells():
		var node: Node3D = presets[parent.get_cell_alternative_tile(t)].instantiate()
		spawn_here.add_child(node)
		node.global_position = Vector3(t.x, node.global_position.y, t.y)
