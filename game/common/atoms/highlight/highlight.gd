extends Node

func highlight() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("highlight")
