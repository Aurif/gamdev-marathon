class_name QuarkAnchor
static var _anchors = {}

static func set_anchor(key: String, node: Node) -> void:
	_anchors[key] = node
	
static func get_anchor(key: String) -> Node:
	return _anchors.get(key)
