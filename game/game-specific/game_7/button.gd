extends Node
class_name G7Button

@export var effect: Dictionary

signal doEffect(effect: Dictionary)
func _on_click(_node: Node) -> void:
	doEffect.emit(effect)
