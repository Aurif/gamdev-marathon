extends Control
class_name MolLevelManager

var levels = []
var current_level_i = 0

signal GameWon()

##
## Initialization
##
func _ready() -> void:
	$LevelLabel.text = levels[current_level_i][0]
	spawn_level()
	
func register_level(name: String, node: MolLevelManager_LevelLayer) -> void:
	levels.append([name, node])

##
## Level spawning
##
func next_level() -> void:
	if current_level_i + 1 > len(levels)-1:
		GameWon.emit()
		return
		
	despawn_level()
	current_level_i += 1
	update_label()
	spawn_level()

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
