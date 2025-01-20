extends Node

func highlight() -> void:
	get_parent().pivot_offset = get_parent().size/2
	$AnimationPlayer.stop()
	$AnimationPlayer.play("highlight")
