extends Node

@export var preset_ball: PackedScene
@export var n_notes: Array[G28Note] = []
@export var n_gradients: Array[Control] = []
@export var n_player: CharacterBody2D

var rng = RandomNumberGenerator.new()
var score = 0
var missed = 0
var current_stage = 0
var spawn_tween: Tween
const MAX_HP = 64
var hp = MAX_HP

var actual_rotation = 0
var rotation_tween: Tween

func _ready() -> void:
	rng.seed = hash("Seed")
	n_notes[0]._show_note()
	_trigger_spawn()

##
## Rotation
##
func _input(event: InputEvent) -> void:
	if QuarkInput.is_right_click(event) and current_stage >= 2:
		actual_rotation = (actual_rotation+90)%180
		if rotation_tween:
			rotation_tween.kill()
		rotation_tween = get_tree().create_tween().bind_node(self)
		rotation_tween.tween_property(n_player, "rotation", deg_to_rad(actual_rotation), 0.1)

##
## Events
##
signal UpdateScore(score: String)
func score_point() -> void:
	score += 1
	UpdateScore.emit(str(score))
	update_hp(1)
	$SoundScore.play()

func take_damage() -> void:
	score -= 2
	missed += 1
	UpdateScore.emit(str(score))
	update_hp(-8)
	$SoundDamage.play()

signal OnFail(message: String)
func update_hp(by: int) -> void:
	hp = min(MAX_HP, hp+by)
	n_player.modulate = lerp(Color.TRANSPARENT, Color.WHITE, float(hp)/MAX_HP)
	if hp <= 0:
		OnFail.emit("Final score: "+str(score)+"\nMissed balls: "+str(missed))
	
##
## Spawning
##
@onready var STAGES = [
	[1.5, 0.35, 30, 50, [_spawn_left], [n_notes[1]._show_note, n_gradients[1].show]],
	[1.5, 0.3, 90, 150, [_spawn_left, _spawn_right], [n_notes[2]._show_note, n_gradients[2].show]],
	[1.4, 0.4, 210, 350, [_spawn_left, _spawn_right, _spawn_top], [n_notes[3]._show_note, n_gradients[3].show]],
	[0.8, 0.4, 450, -1, [_spawn_left, _spawn_right, _spawn_top, _spawn_bottom], [n_notes[3]._show_note, n_gradients[3].show]]
]
func _trigger_spawn() -> void:
	var stage = STAGES[current_stage]
	var previous_stage = [0, 0, 0, 0]
	if current_stage > 0:
		previous_stage = STAGES[current_stage-1]
	
	if score >= stage[3] and current_stage < len(STAGES)-1:
		current_stage += 1
		for f in stage[5]:
			f.call()
		_trigger_spawn()
		return
	
	if spawn_tween:
		spawn_tween.kill()
	spawn_tween = get_tree().create_tween().bind_node(self)
	spawn_tween.tween_callback(_spawn_random)
	spawn_tween.tween_interval(max(stage[1], 
		lerp(stage[0], stage[1], (score-float(previous_stage[3]))/(stage[2]-float(previous_stage[3])))
	))
	spawn_tween.tween_callback(_trigger_spawn)

func _spawn_random() -> void:
	var choices = STAGES[current_stage][4]
	choices[rng.randi_range(0, len(choices)-1)].call()

func _spawn_left() -> void:
	$SoundSpawn.play()
	var viewport = get_viewport().get_visible_rect().size
	var node = preset_ball.instantiate()
	add_child(node)
	node.global_position = Vector2(-20, rng.randi_range(70, viewport.y - 70))
	node.set_direction(Vector2(1, 0))
	node.get_node("SpriteCircle").modulate = Color("#91c2fa")
	var offscreen = node.get_node("Offscreen") as G28OffscreenDetection
	offscreen.direction = "LEFT"
	offscreen.OnScore.connect(score_point)
	offscreen.OnDmg.connect(take_damage)

func _spawn_right() -> void:
	$SoundSpawn.play()
	var viewport = get_viewport().get_visible_rect().size
	var node = preset_ball.instantiate()
	add_child(node)
	node.global_position = Vector2(viewport.x+20, rng.randi_range(70, viewport.y - 70))
	node.set_direction(Vector2(-1, 0))
	node.get_node("SpriteCircle").modulate = Color("#fa9191")
	var offscreen = node.get_node("Offscreen") as G28OffscreenDetection
	offscreen.direction = "RIGHT"
	offscreen.OnScore.connect(score_point)
	offscreen.OnDmg.connect(take_damage)

func _spawn_top() -> void:
	$SoundSpawn.play()
	var viewport = get_viewport().get_visible_rect().size
	var node = preset_ball.instantiate()
	add_child(node)
	node.global_position = Vector2(rng.randi_range(70, viewport.x - 70), -20)
	node.set_direction(Vector2(0, 1))
	node.get_node("SpriteCircle").modulate = Color("#91fa9f")
	var offscreen = node.get_node("Offscreen") as G28OffscreenDetection
	offscreen.direction = "TOP"
	offscreen.OnScore.connect(score_point)
	offscreen.OnDmg.connect(take_damage)

func _spawn_bottom() -> void:
	$SoundSpawn.play()
	var viewport = get_viewport().get_visible_rect().size
	var node = preset_ball.instantiate()
	add_child(node)
	node.global_position = Vector2(rng.randi_range(70, viewport.x - 70), viewport.y+20)
	node.set_direction(Vector2(0, -1))
	node.get_node("SpriteCircle").modulate = Color("#fad591")
	var offscreen = node.get_node("Offscreen") as G28OffscreenDetection
	offscreen.direction = "BOTTOM"
	offscreen.OnScore.connect(score_point)
	offscreen.OnDmg.connect(take_damage)
