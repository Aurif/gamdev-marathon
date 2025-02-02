extends Node

@export var n_shop: MolShop
@export var n_timer: MolTimer
@export var n_label_money: Label
@export var n_label_income: Label

var tickspeed: float = 4000
var tile_amounts = {}

signal Income(amount: int)

func _ready() -> void:
	parse_tick(0)

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
	recalc_tiles()
	
func unregister_tile(tier: int) -> void:
	if tier not in tile_amounts:
		return
	recalc_tiles()

func recalc_tiles() -> void:
	for v in G23Tiers.state.values():
		v.reset()
	
	for t in tile_amounts:
		G23Tiers.TIER_DEFINITIONS[t].calc(tile_amounts[t], G23Tiers.state)
	update_labels()
