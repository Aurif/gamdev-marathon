extends Node

@export var n_button: Node
@export var n_score_label: Label
@export var n_health_controller: MolHealthController
@export var n_fail_screen: MolFailScreen
@export var n_blinker: AnimationPlayer

var button_prefab = PackedScene.new()
var score: int = 0
var current_sequence: Array = []
var current_step: int = 0

var sequence_tween: Tween
var spawn_tween: Tween

var in_sequence: bool = false
var hard_after_sequence = {1: expand_3x3, 2: expand_5x5}
@onready var all_buttons: Array = [n_button]

func _ready() -> void:
	prepare_prefab()
	next_sequence()

#
# Sequence checking
#
func _on_button_clicked(button: Node) -> void:
	if not in_sequence:
		return
	abort_sequence_animation()
	if button != current_sequence[current_step]:
		n_health_controller.take_damage()
		$SoundIncorrect.play()
		return
	current_step += 1
	if current_step >= len(current_sequence):
		after_sequence()
		$SoundSuccess.play()
	else:
		$SoundCorrect.play()

func after_sequence() -> void:
	correct_sequence_animation()
	in_sequence = false
	n_health_controller.full_heal()
	score += 1
	n_score_label.text = "Score: "+str(score)
	if hard_after_sequence.has(score):
		hard_after_sequence[score].call()
	else:
		next_sequence()
		
func next_sequence() -> void:
	in_sequence = false
	if score == 0:
		make_sequence([n_button])
	elif score == 1:
		make_sequence([n_button, n_button])
	else:
		var random_sequence = range(sequence_length()).map(func(n): return (all_buttons.pick_random() as Node))
		make_sequence(random_sequence)

func sequence_displayed() -> void:
	in_sequence = true

#
# Dynamic scaling (math functions)
#
func sequence_length() -> int:
	return ceil(sqrt(float(score-1)/3.0))+2

func rotation_count() -> int:
	return max(0, floor((float(score)**(1.0/3.0)-1.0)*(1.0+sin(2.0*float(score))/4.0)))

#
# Node cloning
#
func prepare_prefab() -> void:
	recurse_prefab(n_button)
	button_prefab.pack(n_button)

func recurse_prefab(current: Node) -> void:
	for node in current.get_children():
		node.set_owner(n_button)
		recurse_prefab(node)

#
# Animations
#
func make_sequence(sequence: Array) -> void:
	sequence_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE)
	sequence_tween.tween_interval(1)
	for node in sequence:
		sequence_tween.tween_callback($SoundSequence.play)
		sequence_tween.tween_property(node.get_node("Polygon2D"), "color", Color("#f9dc90"), 0.3)
		sequence_tween.tween_property(node.get_node("Polygon2D"), "color", Color("#15111a"), 0.3)
	
	apply_rotations()
	sequence_tween.tween_callback(sequence_displayed)
	if score < 2:
		sequence_tween.tween_interval(5)
	else:
		sequence_tween.tween_interval(8)
	sequence_tween.tween_callback(next_sequence)
	
	current_step = 0
	current_sequence = sequence

func apply_rotations() -> void:
	var pos_transform = func(x): return x
	for r in range(rotation_count()):
		var rotator = rotations.values().pick_random()
		pos_transform = func(x): return rotator.call(pos_transform.call(x))
		sequence_tween.tween_callback($SoundShuffle.play)
		sequence_tween.set_parallel(true)
		for but in all_buttons:
			sequence_tween.tween_property(but, "position", pos_transform.call(but.position), 0.7)
		sequence_tween.set_parallel(false)

func abort_sequence_animation() -> void:
	if not sequence_tween.is_valid() or not sequence_tween.is_running():
		return
	sequence_tween.kill()
	for node in all_buttons:
		node.get_node("Polygon2D").color = Color("#15111a")

func correct_sequence_animation() -> void:
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE)
	var max_angle = 0.28
	var transition_time = 0.25
	for i in range(len(all_buttons)):
		if i == 0:
			tween.tween_property(all_buttons[i], "rotation", max_angle, transition_time)
		else:
			tween.parallel().tween_property(all_buttons[i], "rotation", max_angle, transition_time)
	for i in range(len(all_buttons)):
		if i == 0:
			tween.tween_property(all_buttons[i], "rotation", 0, transition_time)
		else:
			tween.parallel().tween_property(all_buttons[i], "rotation", 0, transition_time)
			
	n_blinker.stop()
	n_blinker.play("Blink")

func expand_3x3() -> void:
	spawn_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE)
	spawn_tween.set_parallel()
	spawn_new(Vector2(0, 0), Vector2(-65, -65))
	spawn_new(Vector2(0, 0), Vector2(-65, 0))
	spawn_new(Vector2(0, 0), Vector2(-65, 65))
	spawn_new(Vector2(0, 0), Vector2(0, -65))
	spawn_new(Vector2(0, 0), Vector2(0, 65))
	spawn_new(Vector2(0, 0), Vector2(65, -65))
	spawn_new(Vector2(0, 0), Vector2(65, 0))
	spawn_new(Vector2(0, 0), Vector2(65, 65))
	spawn_tween.set_parallel(false)
	spawn_tween.tween_callback(next_sequence)

func expand_5x5() -> void:
	spawn_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE)
	spawn_tween.set_parallel()
	# Upper
	spawn_new(Vector2(-65, -65), Vector2(-130, -130))
	spawn_new(Vector2(-65, -65), Vector2(-130, -65))
	spawn_new(Vector2(-65, 0), Vector2(-130, 0))
	spawn_new(Vector2(-65, 65), Vector2(-130, 65))
	spawn_new(Vector2(-65, 65), Vector2(-130, 130))
	# Lower
	spawn_new(Vector2(65, -65), Vector2(130, -130))
	spawn_new(Vector2(65, -65), Vector2(130, -65))
	spawn_new(Vector2(65, 0), Vector2(130, 0))
	spawn_new(Vector2(65, 65), Vector2(130, 65))
	spawn_new(Vector2(65, 65), Vector2(130, 130))
	# Left
	spawn_new(Vector2(-65, -65), Vector2(-65, -130))
	spawn_new(Vector2(0, -65), Vector2(0, -130))
	spawn_new(Vector2(65, -65), Vector2(65, -130))
	# Right
	spawn_new(Vector2(-65, 65), Vector2(-65, 130))
	spawn_new(Vector2(0, 65), Vector2(0, 130))
	spawn_new(Vector2(65, 65), Vector2(65, 130))
	spawn_tween.set_parallel(false)
	spawn_tween.tween_callback(next_sequence)
	
func spawn_new(from: Vector2, to: Vector2) -> void:
	var new_node = button_prefab.instantiate()
	new_node.position = from
	n_button.add_sibling(new_node)
	new_node.get_node("Clickable").onClick.connect(_on_button_clicked)
	all_buttons.append(new_node)
	spawn_tween.tween_property(new_node, "position", to, 0.75)

#
# Rotations
#
var rotations = {
	"mirror_x": func (pos: Vector2) -> Vector2: return pos*Vector2(1, -1),
	"mirror_y": func (pos: Vector2) -> Vector2: return pos*Vector2(-1, 1),
	"mirror_center": func (pos: Vector2) -> Vector2: return pos*Vector2(-1, -1),
	"cross_\\": func (pos: Vector2) -> Vector2: return Vector2(pos.y, pos.x),
	"cross_/": func (pos: Vector2) -> Vector2: return Vector2(pos.y*-1, pos.x*-1),
	"rot_90": func (pos: Vector2) -> Vector2: return Vector2(pos.y, pos.x*-1),
	"rot_neg_90": func (pos: Vector2) -> Vector2: return Vector2(pos.y*-1, pos.x),
	"d1_rot_90": func (pos: Vector2) -> Vector2: return Vector2(pos.y, pos.x*-1),
	"d1_rot_neg_90": func (pos: Vector2) -> Vector2: return Vector2(pos.y*-1, pos.x),
	"d2_rot_90": func (pos: Vector2) -> Vector2: return Vector2(pos.y, pos.x*-1),
	"d2_rot_neg_90": func (pos: Vector2) -> Vector2: return Vector2(pos.y*-1, pos.x),
}

#
# Death
#
func _on_death() -> void:
	n_fail_screen.show_screen("Score: "+str(score))
