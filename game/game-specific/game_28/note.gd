extends Control
class_name G28Note

func _input(event: InputEvent) -> void:
	if QuarkInput.is_click(event):
		get_tree().paused = false
		queue_free()

func _show_note() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	self.visible = true
