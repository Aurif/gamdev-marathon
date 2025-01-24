extends Node

@export var n_color: ColorRect
@export var n_instructions: Node
@export var n_fail_screen: MolFailScreen
@export var n_timer: MolTimer

var started = false
var state = 0 
# 0 - transition
# 1 - move
# -1 - don't move

func start_game() -> void:
	n_instructions.visible = false
	started = true
	$TimerSimple.start_timer()
	n_color.visible = true
	transition_move()

func time_until_transition() -> float:
	var cur_time = $TimerSimple.current_time()/10+1
	var ret = randf_range(5/cur_time, 7/sqrt(cur_time))
	return ret

func transition_move() -> void:
	$SoundMove.play()
	state = 0
	n_color.modulate = Color("#5eff5e")
	var tween = get_tree().create_tween()
	tween.tween_interval(0.5)
	tween.tween_callback(
		func(): 
			state = 1
			n_timer.start_timer(200, end_game)
	)
	tween.tween_interval(time_until_transition())
	tween.tween_callback(transition_dont_move)
	

func transition_dont_move() -> void:
	n_timer.stop_timer()
	$SoundNotMove.play()
	state = 0
	n_color.modulate = Color("#f55353")
	var tween = get_tree().create_tween()
	tween.tween_interval(0.5)
	tween.tween_callback(func(): state = -1)
	tween.tween_interval(time_until_transition())
	tween.tween_callback(transition_move)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed and not started:
		start_game()
	if not started or state == 0:
		return
	if event is not InputEventMouseMotion:
		return

	if state == -1:
		end_game()
	if state == 1:
		n_timer.start_timer(200, end_game)
	
func end_game() -> void:
	n_fail_screen.show_screen("You survived "+$TimerSimple.current_time_formatted())
