extends Node
class_name AtomFadeOut

func fade_out() -> void:
	$AnimationPlayer.play("fade_out")
	
func _destroy_parent() -> void:
	get_parent().queue_free()
