extends Node

@export var preset_ball: PackedScene
@export var n_score_label: Label

var score = 0
var ball_speed = 300

func _ready() -> void:
	spawn_ball()

func spawn_ball() -> void:
	var ball = preset_ball.instantiate() as MolBouncingBall
	ball.position = get_viewport().get_visible_rect().size/2
	ball.speed = ball_speed/2
	ball.set_direction(Vector2(randf_range(0, 1), randf_range(0, 1)))
	get_parent().add_child.call_deferred(ball)
	ball.connect_on_collision(0, _on_ball_bounce)

#
# Logic and UI
#
func update_score(new_score: int) -> void:
	score = new_score
	n_score_label.text = "Score: "+str(new_score)

#
# Events
#
func _on_ball_bounce(ball: MolBouncingBall) -> void:
	update_score(score + 1)
	ball.set_speed(ball_speed)
	
func _on_ball_exit(ball: MolBouncingBall) -> void:
	ball.queue_free()
	spawn_ball()
