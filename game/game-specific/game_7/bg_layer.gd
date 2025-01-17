extends TileMapLayer
class_name G7BgLayer

@export var generation_size: Vector2i = Vector2i(22, 12)

func generate() -> void:
	var size_rect = Rect2i(Vector2i.ZERO, generation_size)
	
	var generation_direction = [
		[Vector2i(1, 0), Vector2i(0, randi_range(0, generation_size.y-1))],
		[Vector2i(-1, 0), Vector2i(generation_size.x-1, randi_range(0, generation_size.y-1))],
		[Vector2i(0, 1), Vector2i(randi_range(0, generation_size.x-1), 0)],
		[Vector2i(0, -1), Vector2i(randi_range(0, generation_size.x-1), generation_size.y-1)],
	].pick_random()
	var base_dir = generation_direction[0]
	var current_pos = generation_direction[1]
	
	var directions = {
		-1: Vector2i(Vector2(base_dir).rotated(PI/2)),
		0: base_dir,
		1: Vector2i(Vector2(base_dir).rotated(-PI/2)),
	}
	
	var current_dir = 0
	var path = [current_pos-directions[current_dir]]
	while size_rect.has_point(current_pos):
		var next_dir = current_dir
		
		# Change direction
		if current_dir == 0 and randf() > 0.85:
			next_dir = [-1, 1].pick_random()
		elif randf() > 0.7:
			next_dir = 0
		
		path.append(current_pos)
		current_pos += directions[current_dir]
		current_dir = next_dir
	
	path.append(current_pos)
	self.set_cells_terrain_path(path, 0, 0, false)
