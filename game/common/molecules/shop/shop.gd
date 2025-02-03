extends Node
class_name MolShop

@export var money: float = 0
@export var price_suffix: String = ""
@export var n_label_shop: Label
@export var n_shelf_holder: Control
@export var preset_shelf: PackedScene
@export var preset_item: PackedScene

signal RecalcMoney(money: float)

func add_item(shelf: int, sprite: Node, price: float, callback: Callable, label: String = "") -> MolShop_Item:
	while len(n_shelf_holder.get_children()) <= shelf:
		n_shelf_holder.add_child(preset_shelf.instantiate())
	
	var item = preset_item.instantiate() as MolShop_Item
	item._current_money = func(): return money
	item.price_suffix = price_suffix
	item.set_item.call_deferred(sprite, price, label)
	item.ItemBought.connect(reduce_money)
	item.ItemBought.connect(callback.unbind(1))
	item.ItemBought.connect($SoundBuy.play)
	RecalcMoney.connect(item.recalc_money.unbind(1))
	n_shelf_holder.get_child(shelf).get_node("ShelfContents").add_child(item)
	return item

func clear_shop() -> void:
	for c in n_shelf_holder.get_children():
		c.queue_free()

func set_money(amount: float) -> void:
	money = amount
	RecalcMoney.emit(money)

func add_money(amount: float) -> void:
	money += amount
	RecalcMoney.emit(money)
	
func reduce_money(amount: float) -> void:
	money -= amount
	RecalcMoney.emit(money)

func set_label(label: String) -> void:
	n_label_shop.text = label
