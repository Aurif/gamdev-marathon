extends Node

@export var n_score_label: Label
@export var n_timer: MolTimer
@export var n_instructions: Label
@export var n_win_screen: MolWinScreen
@export var preset_item: PackedScene

var score = 0
var max_score = 0
var next_spawn = 0
var time = 0

var game_started = false
var difficulty = 0.0
const TOTAL_TIME = 60.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed and not game_started:
		start_game()

func start_game() -> void:
	game_started = true
	n_timer.start_timer(TOTAL_TIME*1000+1600, end_game)
	n_instructions.visible = false

func _process(delta: float) -> void:
	if not game_started or difficulty > 1.0:
		return
	difficulty += delta/TOTAL_TIME
	if next_spawn <= 0:
		spawn_item()
		next_spawn += lerp(1.0, 0.15, difficulty)
	next_spawn -= delta

func spawn_item() -> void:
	var item = preset_item.instantiate() as Node2D
	item.position = Vector2(
		randi_range(100, get_viewport().get_visible_rect().size.x-100),
		-150
	)
	item.speed = lerp(150, 800, difficulty)
	item.rotation = randf_range(0, 2*PI)
	max_score += 1
	add_child(item)

func item_click(area: Node2D) -> void:
	score += 1
	n_score_label.text = "Score: "+str(score)
	n_score_label.get_node("Highlight").highlight()
	area.get_parent().queue_free()
	$SoundBreak.play()

func end_game() -> void:
	n_win_screen.show_screen("Score: "+str(score)+"/"+str(max_score))
