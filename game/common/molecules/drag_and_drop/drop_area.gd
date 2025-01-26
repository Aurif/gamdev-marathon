extends Area2D
class_name MolDragAndDrop_DropArea

@export var n_transitions: AtomEffectTransition
@export var anchor: Vector2 = Vector2.ZERO

var currently_holds: Node

func set_highlighted() -> void:
	n_transitions.set_highlight(1, 0.2)
	
func unset_highlighted() -> void:
	n_transitions.set_highlight(0, 0.2)

func drop_here(node: MolDragAndDrop_Draggable, instant: bool = false) -> bool:
	var actual_size = get_child(0).shape.size*get_child(0).global_scale
	node.n_transitions.set_global_position(self.global_position+actual_size*anchor, 0 if instant else 0.1)
	
	if node.current_area:
		node.current_area.currently_holds = null
	if self.currently_holds:
		if not node.current_area:
			return false
		node.current_area.drop_here(currently_holds, instant)
	
	self.currently_holds = node
	node.current_area = self
	unset_highlighted()
	return true
