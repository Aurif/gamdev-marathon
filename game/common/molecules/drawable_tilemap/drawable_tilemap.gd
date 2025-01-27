extends TileMapLayer
class_name MolDrawableTilemap

@export var allowed_rect: Rect2i

var current_brush_tile: Array
var mouseTilePosition: Vector2i

signal OnDraw(tilemap: MolDrawableTilemap)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var newPosition = local_to_map(get_local_mouse_position())
		update_mouse_pos(newPosition)
		
	if (event is InputEventMouseMotion and event.button_mask == 1) or (event is InputEventMouseButton and event.button_index==1 and event.pressed==true):
		draw_tile()

func update_mouse_pos(newPosition: Vector2i) -> void:
	if newPosition == mouseTilePosition:
		return
	$Hover.erase_cell(mouseTilePosition)
	if allowed_rect.has_point(newPosition):
		$Hover.set_cell(newPosition, 0, Vector2i(0, 0))
	mouseTilePosition = newPosition

func draw_tile() -> void:
	if not allowed_rect.has_point(mouseTilePosition):
		return
	if self.get_cell_atlas_coords(mouseTilePosition) == current_brush_tile[0] and self.get_cell_alternative_tile(mouseTilePosition) == current_brush_tile[1]:
		return
	self.set_cell(mouseTilePosition, 0, current_brush_tile[0], current_brush_tile[1])
	OnDraw.emit(self)

func set_current_brush_tile(atlas_pos: Vector2i, variant: int) -> void:
	current_brush_tile = [atlas_pos, variant]
