extends Node

@export var n_shop: MolShop
@export var n_timer: MolTimer
@export var n_grid: MolGrid
@export var n_unlocks: Control
@export var n_label_money: Label
@export var n_label_income: Label

var tickspeed: float = 500
var tile_amounts = {}

signal Income(amount: int)
signal TileChange()

##
## Setup
##
func _ready() -> void:
	parse_tick(0)
	(func(): setup_merge.call_deferred()).call_deferred()

func setup_merge() -> void:
	for n in n_grid.nodes:
		n.get_node("Area2D").on_merge = func(old, new): 
			var it_0 = old.get_parent() as G23Item
			var it_1 = new.get_parent() as G23Item
			if it_0.tier != it_1.tier or it_1.tier+1 not in G23Tiers.TIER_DEFINITIONS:
				return
			
			it_0.get_parent().remove_child(it_0)
			it_0.queue_free()
			it_1.set_tier(it_1.tier+1)
			$SoundMerge.play()

##
## Ticks
##
func parse_tick(ticks: int) -> void:
	Income.emit(G23Tiers.state["income"].get_value()*ticks)
	update_labels()
	n_timer.start_timer(tickspeed, parse_tick.bind(1))
	
func update_labels() -> void:
	n_label_money.text = QuarkNumber.format_number(n_shop.money)+"@"
	n_label_income.text = QuarkNumber.format_number(G23Tiers.state["income"].get_value())+"@/"+str(tickspeed/1000)+"s"

##
## Tiles
##
func register_tile(tier: int) -> void:
	if tier not in tile_amounts:
		tile_amounts[tier] = 0
	tile_amounts[tier] += 1
	check_unlocks()
	recalc_tiles()
	
func unregister_tile(tier: int) -> void:
	if tier not in tile_amounts:
		return
	tile_amounts[tier] -= 1
	recalc_tiles()
	TileChange.emit()

func recalc_tiles() -> void:
	for v in G23Tiers.state.values():
		v.reset()
	
	var amounts_order = tile_amounts.keys()
	amounts_order.reverse()
	for t in amounts_order:
		G23Tiers.TIER_DEFINITIONS[t].calc(tile_amounts[t], G23Tiers.state)
	update_labels()

##
## Unlocks
##
var unlock_defs = [
	[func(): return tile_amounts.get(1, 0) >= 2, "Drag and drop to merge", func(): pass]
]
var unlocks = {}
func check_unlocks() -> void:
	for i in range(len(unlock_defs)):
		if i in unlocks or not unlock_defs[i][0].call():
			continue
		var label = n_unlocks.get_child(i) as Label
		label.text = unlock_defs[i][1]
		label.tooltip_text = ""
		label.get_node("Highlight").highlight()
		$SoundUnlock.play()
		unlocks[i] = true
		
