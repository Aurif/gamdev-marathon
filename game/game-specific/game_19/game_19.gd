extends Node

@export var n_flasher: AtomEffectTransition
@export var n_shop: MolShop
@export var n_label_money: Label
@export var n_win_screen: MolWinScreen
@export var preset_rand_box: PackedScene

func _ready() -> void:
	var items = [
		[static_sum(2, 40, 20), static_sum(5, 500, 100), static_sum(8, 7500, 1000), static_sum(25, 200000, 10000)],
		[static_sum(4, 160, 40), static_sum(20, 4000, 200), static_sum(50, 225000, 5000), static_sum(250, 2000000, 10000)],
		[static_sum(10, 800, 100), static_sum(100, 10000, 100), static_sum(1000, 120000, 100), static_sum(8000, 12000000, 1000)],
	]
	
	for s in range(len(items)):
		for it in items[s]:
			n_shop.add_item(s, it[0], it[1], it[2])
	n_shop.set_label("CASINO")

func display_money(money: float) -> void:
	n_label_money.text = "Money:   "+QuarkNumber.format_number(money)+"$"
	n_label_money.get_node("Highlight").highlight()

func end_game() -> void:
	n_win_screen.show_screen("You left with "+QuarkNumber.format_number(n_shop.money)+"$")

##
## Item types
##
func static_sum(chance: int, reward: float, cost: float):
	return [
		_make_node("1 in "+str(chance), "+"+QuarkNumber.format_number(reward)),
		cost,
		func(): _rand_chance_event(chance, reward)
	]
	
func _make_node(line1: String, line2: String) -> Node:
	var node = preset_rand_box.instantiate()
	node.get_child(0).get_child(0).text = line1
	node.get_child(0).get_child(1).text = line2
	return node

func _rand_chance_event(chance: float, extra_money: float) -> void:
	if randf()<1.0/chance:
		n_shop.add_money(extra_money)
		$SoundWon.play()
		n_flasher.flash_modulate(Color("#3d663d65"), 0.3)
	else:
		$SoundLost.play()
		n_flasher.flash_modulate(Color("#7826286a"), 0.3)
