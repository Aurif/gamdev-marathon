extends TextureRect
class_name MolTimer

@export var animation_player: AnimationPlayer
var current_callback: Callable = func(): return

func start_timer(time: int, callback: Callable) -> void:
	self.visible = true
	animation_player.stop()
	animation_player.play("Shrink", -1, 1000.0/(time as float))
	current_callback = callback

func stop_timer() -> void:
	animation_player.stop()

func execute_callback() -> void:
	if current_callback.is_valid():
		current_callback.call()
	current_callback = func(): return
