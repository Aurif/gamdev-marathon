extends Node

@export var n_time_label: Label
var started = false

signal StartGame()
func start_game() -> void:
	if not started:
		started = true
		$TimerSimple.start_timer()
		StartGame.emit()

func _process(_delta: float) -> void:
	if started:
		n_time_label.text = $TimerSimple.current_time_formatted()
	elif Input.is_action_just_pressed("ui_jump"):
		get_tree().create_timer(0.1).timeout.connect(start_game)

signal OnFail(message: String)
func fail() -> void:
	$SoundLose.play()
	OnFail.emit("You survived for "+$TimerSimple.current_time_formatted())
