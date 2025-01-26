class_name QuarkPhysicsAtPoint

static func gravity(world: World2D, point: Vector2) -> Vector2:
	var params = PhysicsPointQueryParameters2D.new()
	params.collide_with_areas = true
	params.collide_with_bodies = false
	params.position = point
	var intersects = world.direct_space_state.intersect_point(params)
	if len(intersects) == 0:
		return PhysicsServer2D.area_get_param(world.space, PhysicsServer2D.AREA_PARAM_GRAVITY) * PhysicsServer2D.area_get_param(world.space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR)
	var grav_alt = intersects[0].collider as Area2D
	return grav_alt.gravity_direction*grav_alt.gravity
