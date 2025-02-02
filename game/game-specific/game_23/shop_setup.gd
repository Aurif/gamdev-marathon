extends Node

@export var n_item_holder: Node
@export var n_grid: MolGrid
@export var preset_item: PackedScene

var shop_items = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unlock_buy_1.call_deferred()

func unlock_buy_1() -> void:
	var buy1 = $Buy1
	buy1.get_parent().remove_child(buy1)
	shop_items.append($Shop.add_item(0, buy1, 3, insert_tiles.bind(1)))

func insert_tiles(amount: int, tier: int = 1) -> void:
	var empty_tiles = get_empty_tiles()
	for i in range(min(len(empty_tiles), amount)):
		var tile = preset_item.instantiate()
		n_item_holder.add_child(tile)
		empty_tiles[i].drop_here(tile.get_node("Draggable"), true)
	update_condition()

func get_empty_tiles() -> Array:
	return n_grid.nodes \
		.map(func(n): return n.get_node("Area2D") as MolDragAndDrop_DropArea) \
		.filter(func(n): return n.currently_holds == null)

func update_condition() -> void:
	var cond = len(get_empty_tiles())>0
	for it in shop_items:
		(it as MolShop_Item).update_condition(cond)
