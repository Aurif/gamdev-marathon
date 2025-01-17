extends Node

@export var n_lock_layer: TileMapLayer
@export var n_button_layer: TileMapLayer
@export var preset_button: PackedScene
@export var preset_lock: PackedScene

var locks: Dictionary = {}

func _ready() -> void:
	spawn_map_objects()

##
## Map init
##
func spawn_map_objects() -> void:
	spawn_buttons()
	spawn_locks()
	
func spawn_buttons() -> void:
	for tile in n_button_layer.get_used_cells():
		var tile_data = n_button_layer.get_cell_tile_data(tile)
		var button_effect = tile_data.get_custom_data("ButtonEffect")
		if not button_effect:
			continue
		
		var tile_pos = n_button_layer.to_global(n_button_layer.map_to_local(tile))
		var button = preset_button.instantiate() as G7Button
		var offset = {
			Vector2i(5, 0): Vector2(0, -1.5),
			Vector2i(5, 1): Vector2(1.5, 0),
			Vector2i(5, 2): Vector2(0, 1.5),
			Vector2i(5, 3): Vector2(-1.5, 0),
		}[n_button_layer.get_cell_atlas_coords(tile)]
		button.position = tile_pos + offset
		button.effect = button_effect
		button.doEffect.connect(do_effect)
		$Spawnables.add_child.call_deferred(button)

func spawn_locks() -> void:
	for tile in n_lock_layer.get_used_cells():
		var tile_data = n_lock_layer.get_cell_tile_data(tile)
		var lid = tile_data.get_custom_data("Lid")
		if not lid:
			continue
		
		var tile_pos = n_lock_layer.to_global(n_lock_layer.map_to_local(tile))
		var lock = preset_lock.instantiate() as G7Lock
		lock.position = tile_pos
		lock.rotation = deg_to_rad(tile_data.get_custom_data("Rotation"))
		lock.steps = tile_data.get_custom_data("Steps")
		lock.state = tile_data.get_custom_data("State")
		$Spawnables.add_child.call_deferred(lock)
		register_lock(lid, lock)
##
## Gameplay loop
##
func register_lock(lid: int, lock: G7Lock) -> void:
	locks[lid] = lock

func do_effect(effect: Dictionary) -> void:
	for k in effect:
		if not locks.get(k):
			continue
		(locks[k] as G7Lock).update_state(effect[k])
		
	check_win()

func check_win() -> void:
	for lid in locks:
		if locks[lid].state != 0:
			return
	
	print("Victory!")
