extends Node

var _already_first_ticked: bool = false
signal AllGoalsReached

func _process(delta: float) -> void:
	if _already_first_ticked:
		return
	_already_first_ticked = true
	self.add_to_group("goals")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if len(get_tree().get_nodes_in_group("goals")) == 1:
		AllGoalsReached.emit()
	queue_free()
