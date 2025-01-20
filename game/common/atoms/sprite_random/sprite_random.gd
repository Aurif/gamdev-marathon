extends Sprite2D

@export var folder_name: String
@export var update_polygon: Node2D
@export var normalize_size: Vector2 = Vector2.ZERO
@export var sprite_candidates: Array[CompressedTexture2D] = []

func _ready() -> void:
	self.texture = sprite_candidates.pick_random()
	_update_polygon()
	_normalize_size()
	
func _update_polygon() -> void:
	if not _update_polygon:
		return
		
	var bitmap = BitMap.new()
	var texture_size = self.texture.get_size()
	bitmap.create_from_image_alpha(self.texture.get_image())
	var polygon = bitmap.opaque_to_polygons(Rect2i(Vector2i.ZERO, texture_size))[0]
	polygon = Array(polygon).map(func(x): return x - texture_size/2)
	
	update_polygon.polygon = polygon

func _normalize_size() -> void:
	if normalize_size == Vector2.ZERO:
		return
		
	var scale = min(2, sqrt(Rect2(Vector2.ZERO, normalize_size).get_area()/Rect2(Vector2.ZERO, self.texture.get_size()).get_area()))
	self.scale = Vector2(scale, scale)
	if update_polygon:
		update_polygon.scale = Vector2(scale, scale)
