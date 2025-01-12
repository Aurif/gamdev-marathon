extends RigidBody2D
class_name MolBouncingBall

@export var speed: int
var listeners = {}

func set_direction(velocity: Vector2) -> void:
	self.linear_velocity = velocity.normalized() * speed

func set_speed(new_speed: int) -> void:
	if speed == new_speed:
		return
	speed = new_speed
	#self.linear_velocity = self.linear_velocity.normalized() * speed
	
#
# Events
#
func connect_on_collision(layer: int, callback: Callable) -> void:
	if not listeners.get(layer):
		listeners[layer] = []
	listeners[layer].append(callback)

#
# Inner logic
#
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity = state.linear_velocity.normalized() * speed

func _on_body_entered(body: Node) -> void:
	for layer in listeners:
		if not bool(body.collision_layer & (1 << layer)):
			continue
		for listener in listeners[layer]:
			if listener.is_valid():
				listener.call(self)
