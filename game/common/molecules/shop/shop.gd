extends Node

@export var n_temp: Control

@export var money: float = 0
@export var n_shelf_holder: Control
@export var preset_shelf: PackedScene
@export var preset_item: PackedScene

signal RecalcMoney(money: float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	n_temp.get_parent().remove_child.call_deferred(n_temp)
	add_item.call_deferred(0, n_temp, 153, func(): pass)

func add_item(shelf: int, sprite: Node, price: float, callback: Callable, label: String = "") -> void:
	while len(n_shelf_holder.get_children()) <= shelf:
		n_shelf_holder.add_child(preset_shelf.instantiate())
	
	var item = preset_item.instantiate() as MolShop_Item
	item.set_item(sprite, price, label)
	item.ItemBought.connect(callback.unbind(1))
	item.ItemBought.connect(reduce_money)
	RecalcMoney.connect(item.recalc_money)
	item.recalc_money.call_deferred(money)
	n_shelf_holder.get_child(shelf).get_node("ShelfContents").add_child(item)

func clear_shop() -> void:
	for c in n_shelf_holder.get_children():
		c.queue_free()

func reduce_money(amount: float) -> void:
	money -= amount
	RecalcMoney.emit(money)
