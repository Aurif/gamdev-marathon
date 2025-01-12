extends TextureRect
class_name MolFailScreen

var is_restart_armed: bool = false

func show_screen(message: String):
	$TextureRect/VBoxContainer/InsertText.text = message
	$AnimationPlayer.play("Appear")
	

func _input(ev):
	if not is_restart_armed:
		return
	if ev is not InputEventKey or not ev.pressed or ev.echo:
		return
	get_tree().reload_current_scene()
	
func arm_restart():
	is_restart_armed = true
