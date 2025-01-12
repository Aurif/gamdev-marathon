extends Control
class_name MolHealthController

@export var max_health = 3
@export var preset_heart: PackedScene

var current_health = 0
signal onDeath

func _ready() -> void:
	current_health = max_health
	for i in range(max_health):
		var heart = preset_heart.instantiate()
		$HBoxContainer.add_child.call_deferred(heart)

func take_damage() -> void:
	if current_health <= 0:
		return
	current_health -= 1
	
	$Blinker/AnimationPlayer.stop()
	$Blinker/AnimationPlayer.play("Blink")
	
	$HBoxContainer.get_child(current_health).take_damage()
	
	if current_health <= 0:
		onDeath.emit()
