extends Node

@export var n_shop: MolShop
@export var n_timer: MolTimer
@export var n_grid: MolGrid
@export var n_unlocks: Control
@export var n_label_money: Label
@export var n_label_income: Label

var tickspeed: float = 500
var tile_amounts = {}


static var state = {
	"income": DualVar.new(1),
	"T1Boost": DualVar.new(),
	"T2Boost": DualVar.new(),
	"T3Boost": DualVar.new(),
	"T4Boost": DualVar.new(),
}

class DualVar:
	var permanent: float = 0
	var temporary: float = 0
	
	func _init(perm_value: float = 0):
		permanent = perm_value
	
	func add_permanent(value: float) -> void:
		permanent += value
	
	func add_temporary(value: float) -> void:
		temporary += value
	
	func get_value() -> float:
		return permanent + temporary
		
	func reset() -> void:
		temporary = 0
		
	func export() -> Dictionary:
		return {"permanent": permanent}
		
	static func import(data: Dictionary) -> DualVar:
		var v = DualVar.new(data["permanent"])
		return v


signal Income(amount: int)
signal TileChange()

##
## Setup
##
func _ready() -> void:
	parse_tick(0)
	(func(): setup_merge.call_deferred()).call_deferred()
	get_tree().create_timer(0.1).timeout.connect(load_save)
	var autosave = get_tree().create_tween().bind_node(self)
	autosave.tween_interval(3)
	autosave.tween_callback(save)
	autosave.set_loops()

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
	Income.emit(G23Tiers.get_state()["income"].get_value()*ticks)
	for t in get_amounts_order():
		G23Tiers.TIER_DEFINITIONS[t].execute(tile_amounts[t], G23Tiers.get_state())
	update_labels()
	n_timer.start_timer(tickspeed, parse_tick.bind(1))
	
func update_labels() -> void:
	n_label_money.text = QuarkNumber.format_number(n_shop.money)+"@"
	n_label_income.text = QuarkNumber.format_number(G23Tiers.get_state()["income"].get_value())+"@/"+str(tickspeed/1000)+"s"

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
	for v in G23Tiers.get_state().values():
		v.reset()
	
	for t in get_amounts_order():
		G23Tiers.TIER_DEFINITIONS[t].calc(tile_amounts[t], G23Tiers.get_state())
	update_labels()
	get_tree().call_group("item", "update_tooltip")

func get_amounts_order() -> Array:
	var amounts_order = tile_amounts.keys()
	amounts_order.reverse()
	return amounts_order

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
		unlock_unlock(i)
		n_unlocks.get_child(i).get_node("Highlight").highlight()
		$SoundUnlock.play()
		
func unlock_unlock(i: int) -> void:
	var label = n_unlocks.get_child(i) as Label
	label.text = unlock_defs[i][1]
	label.tooltip_text = ""
	unlocks[i] = true
	
##
## Save/Load
##
func save() -> void:
	print("SAVED")
	var state_serialized = {}
	for k in state:
		state_serialized[k] = state[k].export()
	
	var export_data = {
		"state": state_serialized,
		"tile_amounts": tile_amounts,
		"unlocks": unlocks,
		"money": n_shop.money
	}
	
	var file = FileAccess.open("user://savegame.dat", FileAccess.WRITE)
	if file:
		file.store_var(export_data)
		file.close()
	else:
		print("Failed to open file for saving!")

func load_save() -> void:
	var savegame = {}
	if FileAccess.file_exists("user://savegame.dat"):
		var file = FileAccess.open("user://savegame.dat", FileAccess.READ)
		if file:
			savegame = file.get_var()
			file.close()
		
	n_shop.set_money(savegame.money)
	for k in savegame.state:
		state[k] = DualVar.import(savegame.state[k])
	for i in savegame.unlocks:
		unlock_unlock(i)
		
	var tiers = savegame.tile_amounts.keys()
	tiers.reverse()
	for t in tiers:
		n_shop.get_parent().insert_tiles(savegame.tile_amounts[t], t)
	
	recalc_tiles()
