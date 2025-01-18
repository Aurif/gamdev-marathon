extends Control
class_name G8Tile

@export var in_node: bool = false
@export var n_player: Node2D
@export var neighbours: Dictionary

const MOVE_SPEED = 0.2

class NeighbourDefinition:
	var node: G8Tile
	var target_dir: Vector2i
	
	func _init(_node: G8Tile, _target_dir: Vector2i) -> void:
		self.node = _node
		self.target_dir = _target_dir
	
	func move_to() -> void:
		node.enter_player(target_dir)

signal PlayerEntered

func _ready() -> void:
	if in_node:
		n_player.visible = true
		n_player.position = self.size/2

##
## Visual variants
##
func variant_goal() -> void:
	$SpriteTilemap.set_cell(Vector2i(0, 0), 1, Vector2i(15, 3))
	$SpriteTilemap.set_cell(Vector2i(1, 0), 1, Vector2i(17, 3))
	$SpriteTilemap.set_cell(Vector2i(0, 1), 1, Vector2i(15, 5))
	$SpriteTilemap.set_cell(Vector2i(1, 1), 1, Vector2i(17, 5))

##
## Player movement
##
func _process(_delta: float) -> void:
	if not in_node:
		return
	var movement = QuarkInput.four_dir_movement_discrete()
	if movement == Vector2i(0, 0):
		return
		
	if not neighbours.get(movement):
		return
	var next = neighbours[movement] as NeighbourDefinition
		
	in_node = false
	var tween = get_tree().create_tween().bind_node(self)
	$SoundMove.play()
	tween.tween_property(n_player, "position", self.size/2+Vector2(movement)*self.size, MOVE_SPEED).set_trans(Tween.TRANS_SINE)
	next.move_to()

func enter_player(source_dir: Vector2i) -> void:
	n_player.visible = true
	n_player.position = self.size/2+Vector2(source_dir)*self.size
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(n_player, "position", self.size/2, MOVE_SPEED).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(_enter_player_callback)

func _enter_player_callback() -> void:
	in_node = true
	PlayerEntered.emit()

func register_neighbour(source_dir: Vector2i, node: G8Tile, target_dir: Vector2i) -> void:
	assert(not neighbours.get(source_dir), "Tile had more than one neighbour registered for the same side")
	neighbours[source_dir] = NeighbourDefinition.new(node, target_dir)
