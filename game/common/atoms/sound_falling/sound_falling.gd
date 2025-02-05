extends AudioStreamPlayer

@export var trigger_velocity: float = 800

var is_playing = false
var _base_volume

func _ready() -> void:
	_base_volume = volume_db

func _physics_process(delta: float) -> void:
	if get_parent().velocity.y > trigger_velocity and not is_playing:
		is_playing = true
		play()
	
	if get_parent().velocity.y < trigger_velocity and is_playing:
		is_playing = false
		stop()
	
	if is_playing:
		volume_db = linear_to_db(min(1, get_parent().velocity.y/trigger_velocity/20)*db_to_linear(_base_volume))
