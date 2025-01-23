extends Node

@export var n_model: Label
@export var n_display: Label
@export var n_sticky_note: Label
@export var n_overlay: Control
@export var n_win_screen: MolWinScreen

var level = 0
const LEVELS = [
	{
		"pin": "123456",
		"buttons": ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
	},
	{
		"pin": "111111",
		"start": "256",
		"buttons": ["0", "1", "2", "3", "4", "5", "8", "9"]
	},
	{
		"pin": "111115",
		"buttons": ["0", "1", "3", "8", "∑"]
	},
	{
		"pin": "001248",
		"buttons": ["0", "1", "∑"]
	},
	{
		"pin": "101360",
		"buttons": ["0", "1", "∑"]
	},
	{
		"pin": "111191",
		"buttons": ["0", "1", "∑"]
	},
	{
		"pin": "999994",
		"buttons": ["0", "3", "∑", "∑%"]
	},
	{
		"pin": "338995",
		"buttons": ["0", "3", "∑", "∑%"]
	},
	{
		"pin": "238360",
		"buttons": ["0", "2", "3", "∑", "∑%"]
	},
	{
		"pin": "842000",
		"buttons": ["0", "2", "3", "6", "∑", "∑%"]
	},
	{
		"pin": "115555",
		"start": "555555",
		"buttons": ["5", "∑", "∑%"]
	},
	{
		"pin": "000112",
		"buttons": ["2", "--"]
	},
	{
		"pin": "124888",
		"buttons": ["0", "2", "--", "∑", "∑%"]
	},
	{
		"pin": "202040",
		"start": "555555",
		"buttons": ["5", "--", "∑%"]
	}
]

var BUTTONS = {
	"0": {"pos": 9, "func": func(v): return v+"0"},
	"1": {"pos": 0, "func": func(v): return v+"1"},
	"2": {"pos": 1, "func": func(v): return v+"2"},
	"3": {"pos": 2, "func": func(v): return v+"3"},
	"4": {"pos": 3, "func": func(v): return v+"4"},
	"5": {"pos": 4, "func": func(v): return v+"5"},
	"6": {"pos": 5, "func": func(v): return v+"6"},
	"7": {"pos": 6, "func": func(v): return v+"7"},
	"8": {"pos": 7, "func": func(v): return v+"8"},
	"9": {"pos": 8, "func": func(v): return v+"9"},
	"∑": {"func": but_sum},
	"∑%": {"func": but_sum_mod},
	"--": {"func": but_minus_minus}
}

##
## Button functions
##
func but_sum(v):
	var next_v = 0
	for i in v.split():
		next_v += int(i)
	return v+str(min(next_v, 9))
	
func but_sum_mod(v):
	var next_v = 0
	for i in v.split():
		next_v += int(i)
	return v+str(next_v%10)
	
func but_minus_minus(v):
	return "".join(Array(v.split()).map(func(x): return max(0, int(x)-1)))
##
## Level preparation
##
func _ready() -> void:
	load_level()

func load_level() -> void:
	var LETTERS: Array = "QWERTYUIOPASDFGHJKLZXCVBNM1234567890".split()
	n_model.text = "TKB"+str(level+1).lpad(3, "0")+"-"+LETTERS.pick_random()+LETTERS.pick_random()+LETTERS.pick_random()
	
	const NOTE_PREFIX = [
		"The pin is\n%s", "Try %s", "Changed to\n%s", "Intel says\n%s", "Default is\n%s", "Factory set\nto %s", "Last time it\nwas %s", "Guess\n%s", "Maybe\n%s", "Overheard\n%s", "Start with\n%s", "%s", "%s?", "Check\n%s", "Found\n%s\nin manual", "Likely\n%s", "Default is\n%s", "Probaly\n%s", "It's %s", "PIN=%s", "Wasn't it\n%s?", "Backup pin\n%s",
	]
	var cur_level = LEVELS[level]
	n_sticky_note.text = NOTE_PREFIX.pick_random() % cur_level.pin
	n_display.text = cur_level.get("start", "").lpad(6, "!")
	
	
	var numkeys = get_tree().get_nodes_in_group("numkey")
	var positions = {}
	
	var unplaced_buttons = []
	for b in cur_level.buttons:
		var but = BUTTONS[b]
		if but.get("pos") != null and but.pos not in positions:
			positions[but.pos] = b
		else:
			unplaced_buttons.append(b)

	for b in unplaced_buttons:
		var free_positions = Array(range(len(numkeys))).filter(func(x): return x not in positions)
		positions[free_positions.pick_random()] = b
		
	for n in range(len(numkeys)):
		var numkey_signal: Signal = numkeys[n].get_node("Button/Clickable").onClick
		for c in numkey_signal.get_connections():
			numkey_signal.disconnect(c.callable)
		
		if positions.get(n) != null:
			numkeys[n].get_node("Button").visible = true
			numkeys[n].get_node("Button/Label").text = positions[n]
			var but = BUTTONS[positions[n]]
			numkey_signal.connect(parse_button.bind(but.func).unbind(1))
		else:
			numkeys[n].get_node("Button").visible = false

func parse_button(trans: Callable) -> void:
	var new_display: String = trans.call(n_display.text.replace("!", ""))
	new_display = new_display.substr(max(0, len(new_display)-6)).lpad(6, "!")
	n_display.text = new_display

	if new_display == LEVELS[level].pin:
		
		for n in get_tree().get_nodes_in_group("numkey"):
			var numkey_signal: Signal = n.get_node("Button/Clickable").onClick
			for c in n.get_node("Button/Clickable").onClick.get_connections():
				numkey_signal.disconnect(c.callable)
				
		level += 1
		if level >= len(LEVELS):
			var tween = get_tree().create_tween()
			tween.tween_interval(0.3)
			tween.tween_callback(n_win_screen.show_screen.bind("You broken through all the keypads!"))
		else:
			$SoundVictory.play()
			var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
			tween.tween_interval(0.3)
			tween.tween_property(n_overlay, "modulate", Color.WHITE, 0.4)
			tween.tween_callback(load_level)
			tween.tween_property(n_overlay, "modulate", Color.TRANSPARENT, 0.4)
