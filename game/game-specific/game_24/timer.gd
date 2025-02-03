extends Node

func _ready() -> void:
	$TimerSimple.start_timer()

func _process(delta: float) -> void:
	self.text = $TimerSimple.current_time_formatted()

signal OnLose()
func lose() -> void:
	$SoundLost.play()
	OnLose.emit()
