extends Control
class_name MolLevelManager

var levels = []
var current_level_i = 0
var in_animation = false

signal GameWon()

##
## Initialization
##
func _ready() -> void:
	if len(levels) == 0:
		return
	$LevelLabel.text = levels[current_level_i][0]
	spawn_level()
	
func register_level(name: String, node: MolLevelManager_LevelLayer) -> void:
	levels.append([name, node])

##
## Level spawning
##
func next_level() -> void:
	if in_animation:
		return
	in_animation = true
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_interval(0.2)
	tween.tween_callback(next_level_immediate)
	
func next_level_immediate() -> void:
	current_level_i += 1
	if current_level_i > len(levels)-1:
		GameWon.emit()
		return
		
	despawn_level()
	update_label()
	spawn_level()
	in_animation = false

func despawn_level() -> void:
	for child in $SpawnHere.get_children():
		child.queue_free()

func spawn_level() -> void:
	var level_layer = levels[current_level_i][1] as MolLevelManager_LevelLayer
	for child in level_layer.get_children():
		level_layer.remove_child(child)
		$SpawnHere.add_child(child)
		
	level_layer.InitLevel.emit()

##
## Animations
##
func update_label():
	$LevelLabel.text = levels[current_level_i][0]
	$LevelLabel/Highlight.highlight()
	$LevelLabel/SoundLevel.play()

##
## DEBUG
##
func _input(event: InputEvent) -> void:
	if QuarkDebug.DEBUG and QuarkInput.is_right_click(event):
		next_level_immediate()
