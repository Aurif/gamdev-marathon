extends Node

@export var preset_ball: PackedScene
@export var n_score_label: Label
@export var n_health_controller: MolHealthController
@export var n_fail_screen: MolFailScreen
@export var n_win_screen: MolWinScreen
@export var n_pause_label: Label
@export var n_shop: MolShopBasic
@export var n_rotator: AtomInputMouseRotation
@export var n_planck_sprite: Polygon2D

var score = 0
var ball_speed = 300
var state = "paused"
var next_shop = 1
var active_balls: Array[Node] = []

var current_balls = 0
var max_balls = 1

func spawn_ball() -> void:
	if current_balls >= max_balls:
		return
	current_balls += 1
	var ball = preset_ball.instantiate() as MolBouncingBall
	ball.position = get_viewport().get_visible_rect().size/2
	ball.speed = ball_speed/2
	ball.set_direction(Vector2(randf_range(0, 1), randf_range(0, 1)))
	get_parent().add_child.call_deferred(ball)
	ball.connect_on_collision(0, _on_ball_bounce)
	active_balls.append(ball)

#
# Logic and UI
#
func update_score(new_score: int) -> void:
	score = new_score
	n_score_label.text = "Score: "+str(new_score)
	if score < 0:
		n_fail_screen.show_screen("You reached negative score")
	elif score >= 195:
		n_win_screen.show_screen("Score: "+str(score))
	elif score >= 35*next_shop-15:
		enter_shop()

#
# State transition
#
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		if state == "paused":
			n_pause_label.visible = false
			state = "running"
			spawn_ball()

func enter_shop() -> void:
	next_shop += 1
	state = "shop"
	for ball in active_balls:
		if is_instance_valid(ball):
			ball.queue_free()
	active_balls = []
	n_shop.show_shop()

func exit_shop() -> void:
	state = "running"
	spawn_ball()

#
# Events
#
func _on_ball_bounce(ball: MolBouncingBall) -> void:
	update_score(score + 1)
	if current_balls < max_balls:
		spawn_ball()
	ball.set_speed(ball_speed)
	
func _on_ball_exit(ball: MolBouncingBall) -> void:
	ball.queue_free()
	current_balls -= 1
	if state != "running":
		return
	n_health_controller.take_damage()
	spawn_ball()

func _on_death() -> void:
	n_fail_screen.show_screen("Score: "+str(score))


#
# Difficulty
#
func _ready() -> void:
	n_shop.choices = {
		"90_degrees": {"sprite": load("res://game-specific/game_2/abilities/90_degrees.png"), "callback": diff_rot_90},
		"180_degrees": {"sprite": load("res://game-specific/game_2/abilities/180_degrees.png"), "callback": diff_rot_180},
		"damage": {"sprite": load("res://game-specific/game_2/abilities/damage.png"), "amount": 3, "callback": n_health_controller.take_damage},
		"invisible": {"sprite": load("res://game-specific/game_2/abilities/invisible.png"), "callback": diff_invisible},
		"speed": {"sprite": load("res://game-specific/game_2/abilities/speed.png"), "amount": 4, "callback": diff_speed},
		"two_balls": {"sprite": load("res://game-specific/game_2/abilities/two_balls.png"), "callback": diff_two_balls},
		"x_movement": {"sprite": load("res://game-specific/game_2/abilities/x_movement.png"), "callback": x_movement},
		"y_movement": {"sprite": load("res://game-specific/game_2/abilities/y_movement.png"), "callback": y_movement},
	}

func diff_rot_90() -> void:
	n_rotator.offset_angle += 90

func diff_rot_180() -> void:
	n_rotator.offset_angle += 180
	
func diff_invisible() -> void:
	n_planck_sprite.visible = false
	
func diff_speed() -> void:
	ball_speed += 100

func diff_two_balls() -> void:
	max_balls = 2
	n_shop.choices["three_balls"] = {"sprite": load("res://game-specific/game_2/abilities/three_balls.png"), "callback": diff_three_balls}

func diff_three_balls() -> void:
	max_balls = 3

func x_movement() -> void:
	(n_rotator.get_node("XMovement") as AnimationPlayer).play("move", -1, 0.4)

func y_movement() -> void:
	(n_rotator.get_node("YMovement") as AnimationPlayer).play("move", -1, 2.1)
