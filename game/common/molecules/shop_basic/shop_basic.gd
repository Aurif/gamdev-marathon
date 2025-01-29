extends TextureRect
class_name MolShopBasic

@export var items: Array[TextureRect]
@export var choices: Dictionary

signal shop_closed

var picked: Dictionary = {}
var current_choices: Array[String] = []

#
# Events
#
func _ready() -> void:
	for i in range(len(items)):
		items[i].gui_input.connect(_on_option_input.bind(i))
	
func _on_option_input(event: InputEvent, i: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		pick_choice(i)
	
func pick_choice(i: int) -> void:
	if i >= len(current_choices):
		return
	picked[current_choices[i]] = picked.get(current_choices[i], 0)+1
	choices[current_choices[i]].callback.call()
	current_choices = []
	hide_shop()

#
# Visibility
#
func show_shop() -> void:
	current_choices = pick(len(items))
	for i in range(len(items)):
		items[i].texture = choices[current_choices[i]].sprite
	$AnimationPlayer.stop()
	$AnimationPlayer.play("appear")
	
func hide_shop() -> void:
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("disappear")

func _on_shop_hidden() -> void:
	shop_closed.emit()

#
# Randomization
#
func pick(n: int) -> Array[String]:
	var valid_choices: Array[String] = []
	for key in choices:
		if picked.get(key, 0) >= choices[key].get("amount", 1):
			continue
		valid_choices.append(key)
	valid_choices.shuffle()
	return valid_choices.slice(0, n)
