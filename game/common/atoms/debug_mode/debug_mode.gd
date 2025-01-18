extends Node2D

func _ready() -> void:
	if self.visible:
		QuarkDebug.DEBUG = true
