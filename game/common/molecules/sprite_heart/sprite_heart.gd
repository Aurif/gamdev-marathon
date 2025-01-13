extends Node
class_name MolSpriteHeart

func take_damage() -> void:
	$MarginContainer/SpriteHeart/AnimationPlayer.play("TakeDamage")

func heal() -> void:
	$MarginContainer/SpriteHeart/AnimationPlayer.stop()
	$MarginContainer/SpriteHeart/AnimationPlayer.play("RESET")
