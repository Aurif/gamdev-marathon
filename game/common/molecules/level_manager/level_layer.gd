extends Node
class_name MolLevelManager_LevelLayer

signal InitLevel()

func _ready() -> void:
	self.visible = false
	assert(self.name.find("Level") == 0, "Unknown level name")
	var label = "Level "+self.name.right(-5)
	(get_parent() as MolLevelManager).register_level(label, self)
