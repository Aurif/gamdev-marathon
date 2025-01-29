extends Node
class_name MolShop_Item

@export var n_item_holder: Control
@export var n_label_price: Label
@export var n_highlight_sprite: Control

var item_price: float
var can_buy: bool = false

signal ItemBought(price: float)

func _ready() -> void:
	n_highlight_sprite.mouse_entered.connect(_on_mouse_entered)
	n_highlight_sprite.mouse_exited.connect(_on_mouse_exited)
	n_highlight_sprite.gui_input.connect(_on_input)
	
func _on_mouse_entered() -> void:
	if not can_buy:
		return
	n_highlight_sprite.get_node("EffectTransition").set_highlight(1, 0.2)
	n_label_price.get_node("EffectTransition").set_modulate(Color("#f9dc90"), 0.2)
	
func _on_mouse_exited() -> void:
	n_highlight_sprite.get_node("EffectTransition").set_highlight(0, 0.2)
	n_label_price.get_node("EffectTransition").set_modulate(Color("#15111a"), 0.2)

func _on_input(event: InputEvent) -> void:
	if not can_buy:
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

func recalc_money(money: float) -> void:
	can_buy = money >= item_price
	
	if can_buy:
		n_item_holder.modulate = Color.WHITE
	else:
		n_item_holder.modulate = Color("#ffffff61")
		_on_mouse_exited()
