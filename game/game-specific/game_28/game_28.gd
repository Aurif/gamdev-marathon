extends Node

@export var preset_ball: PackedScene
@export var n_notes: Array[G28Note] = []
@export var n_gradients: Array[Control] = []

var rng = RandomNumberGenerator.new()
var score = 0
var current_stage = 0
var spawn_tween: Tween

func _ready() -> void:
	rng.seed = hash("Seed")
	n_notes[0]._show_note()
	_trigger_spawn()

##
## Events
##
signal UpdateScore(score: String)
func score_point() -> void:
	score += 1
	UpdateScore.emit(str(score))
	$SoundScore.play()

func take_damage() -> void:
	score -= 2
	UpdateScore.emit(str(score))
	$SoundDamage.play()

##
## Spawning
##
@onready var STAGES = [
	[1.5, 0.35, 30, 50, [_spawn_left], [n_notes[1]._show_note, n_gradients[1].show]],
	[1.5, 0.3, 90, 150, [_spawn_left, _spawn_right], []]
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
