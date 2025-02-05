extends CharacterBody2D

@export var gravity: Vector2 = Vector2(0, 2)
@export var move_speed: int = 250
@export var jump_strength: float = 350

func _physics_process(delta: float) -> void:
	if self.is_on_floor():
		velocity -= gravity*jump_strength*QuarkInput.jump()
		if QuarkInput.jump() > 0:
			$SoundJump.play()
	else:
		velocity += gravity*delta*1000
	velocity.x = QuarkInput.left_right_movement().x * move_speed
	
	self.move_and_slide()
