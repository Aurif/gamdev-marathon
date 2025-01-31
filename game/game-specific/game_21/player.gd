extends Node

signal NextLevel()

func _ready() -> void:
	$Area2D.body_entered.connect(func(x): NextLevel.emit())
