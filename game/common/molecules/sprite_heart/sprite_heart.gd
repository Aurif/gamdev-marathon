extends Node
class_name MolSpriteHeart

func take_damage() -> void:
	$MarginContainer/SpriteHeart/AnimationPlayer.play("TakeDamage")
