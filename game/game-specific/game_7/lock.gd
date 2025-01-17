extends Node
class_name G7Lock

@export var steps: int = 4
@export var state: int = 0
@export var lid: int

var rotation_tween: Tween
signal register(lid: int, lock: G7Lock)
func _ready() -> void:
	update_state(0, true)
	register.emit(lid, self)

func update_state(delta: int, immediate: bool = false) -> void:
	var anim_state = state + delta
	state = (state+delta)%steps
	if state < 0:
		state += steps
		
	var modulate_color = Color("#ff4242")
	if state == 0:
		modulate_color = Color("#8b7399")
	
	if rotation_tween and rotation_tween.is_valid():
		rotation_tween.custom_step(0.2)
		rotation_tween.kill()
	
	if immediate == true:
		$Rotation.rotation = PI*2/steps*state
		$Rotation/Arrow.modulate = modulate_color
	else:
		rotation_tween = get_tree().create_tween().bind_node(self)
		rotation_tween.tween_property($Rotation, "rotation", PI*2/steps*anim_state, 0.2).set_trans(Tween.TRANS_SINE)
		rotation_tween.parallel().tween_property($Rotation/Arrow, "modulate", modulate_color, 0.2).set_trans(Tween.TRANS_SINE)
		rotation_tween.tween_property($Rotation, "rotation", PI*2/steps*state, 0)
		rotation_tween.play()
