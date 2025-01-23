extends Node

@export var n_time_label: Label
@export var n_intro_label: Label
@export var n_timer: MolTimer
@export var n_fail_screen: MolFailScreen

var started: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.mouse_entered.connect(_on_enter)
	$Area2D.mouse_exited.connect(_on_exit)


func _on_enter() -> void:
	if not started:
		start()
		return
	n_timer.stop_timer()
	
func _on_exit() -> void:
	n_timer.start_timer(250, func(): n_fail_screen.show_screen("Your time: "+$TimerSimple.current_time_formatted()))

func _process(delta: float) -> void:
	if started:
		n_time_label.text = $TimerSimple.current_time_formatted()

func start() -> void:
	move_next()
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(self, "scale", Vector2(0.7, 0.7), 30)
	tween.tween_property(self, "scale", Vector2(0.5, 0.5), 45)
	$TimerSimple.start_timer()
	n_intro_label.visible = false
	started = true

var speed = 100
func move_next() -> void:
	speed += 20
	const MARGIN = 50
	var viewport = get_viewport().get_visible_rect().size
	var tween = get_tree().create_tween().bind_node(self)
	
	var new_pos = self.position
	while self.position.distance_to(new_pos) < 150:
		new_pos = Vector2(
			randi_range(MARGIN, viewport.x-MARGIN),
			randi_range(MARGIN, viewport.y-MARGIN)
		)
	tween.tween_property(self, "position", 
		new_pos,
		self.position.distance_to(new_pos)/speed
	).set_trans(Tween.TRANS_SINE)
	
	tween.tween_interval(10/sqrt(speed))
	tween.tween_callback(move_next)
