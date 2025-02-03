extends Node

@export var n_item_holder: Node
@export var n_grid: MolGrid
@export var preset_item: PackedScene
@export var override_tier: int = 0

var shop_items = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not QuarkAutosave.SHOULD_INIT:
		return
	unlock_buy_1.call_deferred()

func unlock_buy_1() -> void:
	var buy1 = $Buy1
	buy1.get_parent().remove_child(buy1)
	shop_items.append($Shop.add_item(0, buy1, 2, insert_tiles.bind(1)))

func insert_tiles(amount: int, tier: int = 1) -> void:
	var empty_tiles = get_empty_tiles()
	for i in range(min(len(empty_tiles), amount)):
		var tile = preset_item.instantiate()
		if override_tier != 0:
			tile.set_tier(override_tier)
		else:
			tile.set_tier(tier)
		n_item_holder.add_child(tile)
		empty_tiles[i].drop_here(tile.get_node("Draggable"), true)
	update_condition()

func get_empty_tiles() -> Array:
	return n_grid.nodes \
		.map(func(n): return n.get_node("Area2D") as MolDragAndDrop_DropArea) \
		.filter(func(n): return n.currently_holds == null)

func update_condition() -> void:
	var empty_count = len(get_empty_tiles())
	for it in shop_items:
		(it as MolShop_Item).update_condition(empty_count > 0)
		(it as MolShop_Item).update_price(pow(2.0, (64-empty_count+1)))
