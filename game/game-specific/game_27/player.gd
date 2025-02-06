extends RigidBody2D

@export var preset_particles: PackedScene

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_jump"):
		apply_force(Vector2(0, -30000).rotated(rotation))
		var particles = preset_particles.instantiate()
		add_child(particles)
		particles.emitting = true
		$SoundBooster.play()
