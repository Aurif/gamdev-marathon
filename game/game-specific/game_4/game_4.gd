extends Node

@export var n_time_label: Label
@export var n_fail_screen: MolFailScreen
@export var prefab_bullet: PackedScene

func _ready() -> void:
	$TimerSimple.start_timer()

func _on_hit(area: Area2D) -> void:
	$DeathSound.play()
	n_fail_screen.show_screen("Your time: "+$TimerSimple.current_time_formatted())

#
# Timing attacks
#
var diff: float = 1.5
var d: float = 0.0
func _process(delta: float) -> void:
	diff += (0.07+diff/200)*delta
	d += diff * delta
	n_time_label.text = "Time: "+$TimerSimple.current_time_formatted()

func attack_large() -> void:
	perform_attack(d)

func attack_medium() -> void:
	perform_attack(d*0.4)

func attack_small() -> void:
	perform_attack(d*0.04)
	
func perform_attack(max_d: float) -> void:
	var chosen_attack = attack_patterns.keys().filter(func(x): return x <= max_d).max()
	if chosen_attack == null:
		return
	attack_patterns[chosen_attack].call()
	d -= chosen_attack

#
# Attack patterns
#
var attack_patterns = {
	1: att_bone_rand,
	3: att_bone_player,
	6: att_bone_homing,
	10: att_cross,
	13: att_bone_slow,
	20: att_fan,
	24: att_cluster,
	32: att_series,
	48: att_wall,
	54: att_wall_holes
}
func sound(scale: float, repeat: int = 1) -> void:
	var callback = func():
		$SpawnSound.pitch_scale = scale
		$SpawnSound.play()
	
	if repeat == 1:
		callback.call()
	else:
		var tween = get_tree().create_tween()
		for i in range(repeat):
			tween.tween_callback(callback)
			tween.tween_interval(0.1)

func att_bone_rand() -> void:
	sound(1)
	spawn_bone("", "rand")

func att_bone_player() -> void:
	sound(1.2)
	spawn_bone("", "player", 125)
	
func att_bone_homing() -> void:
	sound(1.5)
	add_homing(spawn_bone("", "rand", 125)[0])
	
func att_cross() -> void:
	sound(0.6)
	spawn_bone("R", "player", 100)
	spawn_bone("D", "player", 100)
	spawn_bone("U", "player", 100)
	spawn_bone("L", "player", 100)

func att_bone_slow() -> void:
	sound(0.8)
	spawn_bone("", "rand", 25)

func att_fan() -> void:
	sound(0.4, 2)
	var meta = spawn_bone("", "rand", 100)
	for i in range(-2, 2):
		if i == 0:
			continue
		var bone = spawn_bone(meta[1], meta[2], 100)[0]
		bone.rotation += 0.16*i

func att_cluster() -> void:
	sound(0.4, 2)
	var meta = spawn_bone("", "rand", 100)
	meta[0].rotation += randf_range(-0.64, 0.64)
	for i in range(7):
		var bone = spawn_bone(meta[1], meta[2], 100)[0]
		bone.rotation += randf_range(-0.64, 0.64)

func att_series() -> void:
	sound(2.4, 4)
	var meta = spawn_bone("", "rand", 100)
	var dist = randi_range(-5, 5)
	if dist == 0:
		dist = 1
	dist *= 16
	
	add_homing(meta[0])
	for i in range(7):
		var bone = spawn_bone(meta[1], meta[2]+dist*i, 100)[0]
		add_homing(bone)
		bone.rotation += randf_range(-0.07, 0.07)

func att_wall() -> void:
	sound(0.2)
	var meta = spawn_bone("", "rand", 50)
	for i in range(-5, 5):
		if i == 0:
			continue
		var bone = spawn_bone(meta[1], meta[2]+16*i, 50)[0]

func att_wall_holes() -> void:
	sound(0.2)
	var meta = spawn_bone("", "rand", 50)
	for i in range(-5, 5):
		if i == 0:
			continue
		var bone = spawn_bone(meta[1], meta[2]+64*i, 50)[0]
#
# Attack patterns - base
#
const MARGIN = 25
func spawn_bone(direction: String, position, speed: int = 150) -> Array:
	var bone = prefab_bullet.instantiate() as Node2D
	bone.get_node("MoveForward").speed = speed+randi_range(-7, 3)
	add_sibling(bone)
	var viewport = get_viewport().get_visible_rect().size
	
	if direction == "":
		direction = ["R", "L", "U", "D"].pick_random()
	
	if str(position) == "rand" and (direction == "R" or direction == "L"):
		position = randi_range(MARGIN, viewport.y - MARGIN)
	if str(position) == "rand" and (direction == "U" or direction == "D"):
		position = randi_range(MARGIN, viewport.x - MARGIN)
		
	if str(position) == "player" and (direction == "R" or direction == "L"):
		position = get_viewport().get_mouse_position().y
	if str(position) == "player" and (direction == "U" or direction == "D"):
		position = get_viewport().get_mouse_position().x
	
	
	if direction == "R":
		bone.position = Vector2i(viewport.x + MARGIN, position)
		bone.rotation = deg_to_rad(180)
	if direction == "L":
		bone.position = Vector2i(-MARGIN, position)
		bone.rotation = deg_to_rad(0)
	if direction == "U":
		bone.position = Vector2i(position, -MARGIN)
		bone.rotation = deg_to_rad(90)
	if direction == "D":
		bone.position = Vector2i(position, viewport.y + MARGIN)
		bone.rotation = deg_to_rad(270)
		
	return [bone, direction, position]

func add_homing(bone: Node2D) -> void:
	bone.rotation = (get_viewport().get_mouse_position() - bone.position).angle()
