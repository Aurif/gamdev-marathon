extends Node
class_name MolLevelManager_LevelLayer

@export var label: String = ""

signal InitLevel()

func _ready() -> void:
	self.visible = false
	var _label = label
	if _label == "":
		assert(self.name.find("Level") == 0, "Unknown level name")
		_label = "Level "+self.name.right(-5)
	(get_parent() as MolLevelManager).register_level(_label, self)
