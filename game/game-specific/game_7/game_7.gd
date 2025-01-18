extends Node

@export var n_lock_layer: TileMapLayer
@export var n_button_layer: TileMapLayer
@export var n_background: G7FancyBackground
@export var n_label_level: Label
@export var preset_button: PackedScene
@export var preset_lock: PackedScene
@export var n_win_screen: MolWinScreen

var locks: Dictionary = {}
var level: int = 0

func _ready() -> void:
	spawn_level()
	spawn_map_objects()

##
## Transitions
##
func transition_out(delay: float) -> void:
	var tween_fg = get_tree().create_tween().bind_node(self)
	tween_fg.tween_interval(delay)
	transition_foreground_out(tween_fg)
	
	var tween_bg = get_tree().create_tween().bind_node(self)
	tween_bg.tween_interval(delay)
	tween_bg.tween_callback(n_background.transition_out)
	
	var tween_next = get_tree().create_tween().bind_node(self)
	tween_next.tween_interval(delay+1.5)
	tween_next.tween_callback(update_label)
	tween_next.tween_interval(0.4)
	tween_next.tween_callback(n_background.transition_in)
	tween_next.tween_interval(1.0)
	tween_next.tween_callback(fade_in_next_level)
	tween_next.tween_property(get_parent(), "modulate", Color.WHITE, 0.1)
	
func transition_foreground_out(tween: Tween) -> void:
	locks = {}
	
	for button in $SpawnedButtons.get_children():
		button.queue_free()
	
	var lock_nodes = $SpawnedLocks.get_children()
	lock_nodes.shuffle()
		
	var tile_destroy_callback = []
	for tile in n_lock_layer.get_used_cells():
		tile_destroy_callback.append(func(): n_lock_layer.erase_cell(tile))
	for tile in n_button_layer.get_used_cells():
		tile_destroy_callback.append(func(): n_button_layer.erase_cell(tile))
	tile_destroy_callback.shuffle()
	
	var speed = 1.0/(len(lock_nodes)+len(tile_destroy_callback))
	for lock in lock_nodes:
		tween.tween_callback(lock.queue_free)
		tween.tween_interval(speed)
	for callback in tile_destroy_callback:
		tween.tween_callback(callback)
		tween.tween_interval(speed)

func update_label() -> void:
	level += 1
	n_label_level.text = "Level "+str(level)
	n_label_level.get_node("Highlight").highlight()
	$LevelSound.play()

func fade_in_next_level() -> void:
	spawn_level()
	spawn_map_objects()
	get_parent().modulate = Color.TRANSPARENT
	
##
## Map init
##
func spawn_level() -> void:
	var tileset = n_lock_layer.tile_set
	n_button_layer.clear()
	n_button_layer.set_pattern(
		Vector2i(-1, -1), 
		tileset.get_pattern(level*2)
	)
	n_lock_layer.clear()
	n_lock_layer.set_pattern(
		Vector2i(-1, -1), 
		tileset.get_pattern(level*2+1)
	)
	
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
		$SpawnedButtons.add_child.call_deferred(button)

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
		lock.lid = lid
		$SpawnedLocks.add_child.call_deferred(lock)
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
	
	if (level+1)*2 >= n_lock_layer.tile_set.get_patterns_count():
		$FanfareSound.play()
		var tween_win = get_tree().create_tween().bind_node(self)
		tween_win.tween_interval(0.4)
		tween_win.tween_callback(n_win_screen.show_screen.bind("Congratulations ^^"))
	else:
		$VictorySound.play()
		transition_out(0.4)
