extends MarginContainer
class_name MolSpriteHeart

func take_damage() -> void:
	$SpriteHeart/AnimationPlayer.play("TakeDamage")
