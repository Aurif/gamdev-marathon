extends Line2D
class_name MolThrowWithTrajectory_Trajectory

@export var max_points = 300
@export var max_bounces = 3

func update_trajectory(vel: Vector2, gravity: Vector2, delta: float = 0.01) -> void:
	var bounces_left = max_bounces
	clear_points()
	var pos: Vector2 = Vector2.ZERO
	for i in max_points:
		if bounces_left <= 0:
			return
				
		add_point(pos)
		vel += gravity * delta
	
		var collision = $CollisionTest.move_and_collide(vel * delta, true)
		if collision and i>0:
			vel = vel.bounce(collision.get_normal()) * 0.6
			bounces_left -= 1

		pos += vel * delta
		$CollisionTest.position = pos
