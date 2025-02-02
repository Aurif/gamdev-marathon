extends Node

@export var n_tilemap: TileMapLayer
@export var n_mouse: Node2D

signal OnStart()
signal OnLose(message: String)
var game_started = false

func start_game() -> void:
	OnStart.emit()
	$TimerSimple.start_timer()
	game_started = true
	
func lose() -> void:
	if not game_started:
		return
	$SoundDeath.play()
	OnLose.emit("You survived for "+$TimerSimple.current_time_formatted())

func _physics_process(delta: float) -> void:
	if game_started:
		n_tilemap.position += Vector2.DOWN*delta*400
	else:
		n_mouse.global_position = get_viewport().get_mouse_position()
