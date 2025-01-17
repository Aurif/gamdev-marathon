extends TextureRect
class_name MolFailScreen

var is_restart_armed: bool = false
var disable_restart: bool = false

func show_screen(message: String):
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$TextureRect/VBoxContainer/InsertText.text = message
	$AnimationPlayer.play("Appear")
	

func _input(ev):
	if not is_restart_armed:
		return
	if ev is not InputEventKey or not ev.pressed or ev.echo:
		return
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func arm_restart():
	if not disable_restart:
		is_restart_armed = true
