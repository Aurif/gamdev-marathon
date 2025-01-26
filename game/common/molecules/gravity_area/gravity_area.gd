extends Node2D

@export var gravity_overwrite: Vector2
var previous_gravity = {}

func _ready() -> void:
	print(get_canvas_layer_node())

#
#func _on_body_entered(body: Node2D) -> void:
	#if not "gravity" in body:
		#return
	#previous_gravity[body] = body.gravity
	#body.gravity = gravity_overwrite
#
#
#func _on_body_exited(body: Node2D) -> void:
	#if previous_gravity.get(body):
		#body.gravity = previous_gravity[body]
		#previous_gravity.erase(body)
