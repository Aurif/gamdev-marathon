extends Node3D

@export var n_player: CharacterBody3D
signal UpdateDistance(value: String)
signal WinGame()

func _process(_delta: float) -> void:
	var dist = round(global_position.distance_to(n_player.global_position))
	UpdateDistance.emit(str(dist)+"m")
	if dist < 25:
		WinGame.emit()
		get_tree().paused = true
