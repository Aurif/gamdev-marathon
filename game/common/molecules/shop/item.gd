extends Node
class_name MolShop_Item

@export var n_item_holder: Control
@export var n_label_price: Label
@export var n_highlight_sprite: Control

var item_price: float
var can_afford: bool = false
var can_buy_condition: bool = true

signal ItemBought(price: float)

func _ready() -> void:
	n_highlight_sprite.mouse_entered.connect(_on_mouse_entered)
	n_highlight_sprite.mouse_exited.connect(_on_mouse_exited)
	n_highlight_sprite.gui_input.connect(_on_input)
	
func _on_mouse_entered() -> void:
	if not can_buy():
		return
	n_highlight_sprite.get_node("EffectTransition").set_highlight(1, 0.2)
	n_label_price.get_node("EffectTransition").set_modulate(Color("#f9dc90"), 0.2)
	
func _on_mouse_exited() -> void:
	n_highlight_sprite.get_node("EffectTransition").set_highlight(0, 0.2)
	n_label_price.get_node("EffectTransition").set_modulate(Color("#15111a"), 0.2)

func _on_input(event: InputEvent) -> void:
	if not can_buy():
		return
	if QuarkInput.is_click(event):
		ItemBought.emit(item_price)

func set_item(sprite: Node, price: float, label: String = "") -> void:
	for c in n_item_holder.get_children():
		c.queue_free()
	n_item_holder.add_child(sprite)
	
	item_price = price
	n_label_price.text = QuarkNumber.format_number(price)
	
	n_highlight_sprite.tooltip_text = label


##
## Locking/Unlocking item
##
func can_buy() -> bool:
	return can_afford and can_buy_condition
	
func refresh_can_buy() -> void:
	if can_buy():
		n_item_holder.modulate = Color.WHITE
	else:
		n_item_holder.modulate = Color("#ffffff61")
		_on_mouse_exited()
	
func recalc_money(money: float) -> void:
	can_afford = money >= item_price
	refresh_can_buy()

func update_condition(condition: bool) -> void:
	can_buy_condition = condition
	refresh_can_buy()
