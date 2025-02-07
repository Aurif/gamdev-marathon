extends Node
class_name G28OffscreenDetection

var direction: String

signal OnScore()
signal OnDmg()

func _on_screen_exited() -> void:
	if _should_score(get_parent().global_position):
		OnScore.emit()
	else:
		OnDmg.emit()
	get_parent().queue_free()
	
func _should_score(pos: Vector2) -> bool:
	var viewport = get_viewport().get_visible_rect().size
	if direction == "LEFT" and pos.x < 0 and pos.y >= 0 and pos.y <= viewport.y:
		return true
	if direction == "RIGHT" and pos.x > viewport.x and pos.y >= 0 and pos.y <= viewport.y:
		return true
	if direction == "TOP" and pos.y < 0 and pos.x >= 0 and pos.x <= viewport.x:
		return true
	if direction == "BOTTOM" and pos.y > viewport.y and pos.x >= 0 and pos.x <= viewport.x:
		return true
	return false
