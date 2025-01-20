extends Node2D

@export var resize_on_click: bool = true
@export var click_sound: bool = true

signal ClickedArea(area: Area2D)

func __on_mouse_click():
	if click_sound:
		$SoundClick.play()
	if resize_on_click:
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_property($SpriteCircle, "scale", Vector2(0.6, 0.6), 0.1).set_trans(Tween.TRANS_SINE)
		tween.tween_property($SpriteCircle, "scale", Vector2(1, 1), 0.1).set_trans(Tween.TRANS_SINE)
		
	for area in $Area2D.get_overlapping_areas():
		ClickedArea.emit(area)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		__on_mouse_click()
