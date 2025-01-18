extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_two(
		$ColorRect, Vector2i.LEFT,
		$ColorRect2, Vector2i.RIGHT
	)
	connect_two(
		$ColorRect2, Vector2i.UP,
		$ColorRect3, Vector2i.RIGHT
	)
	connect_two(
		$ColorRect3, Vector2i.LEFT,
		$ColorRect4, Vector2i.UP
	)
	connect_two(
		$ColorRect4, Vector2i.DOWN,
		$ColorRect, Vector2i.RIGHT
	)


func connect_two(node1: G8Tile, dir1: Vector2i, node2: G8Tile, dir2: Vector2i) -> void:
	node1.register_neighbour(dir1, node2, dir2)
	node2.register_neighbour(dir2, node1, dir1)
