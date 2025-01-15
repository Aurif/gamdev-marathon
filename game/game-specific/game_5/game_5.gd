extends Node

@export var polygons: Array[Polygon2D]
@export var colors: Dictionary
@export var n_health_controller: MolHealthController
@export var n_label_score: Label
@export var n_label_time: Label
@export var n_fail_screen: MolFailScreen
@export var n_win_screen: MolWinScreen
@export var n_sequence_display: Node
@export var n_intro_buttons: Node
@export var n_intro_fadeout: AtomFadeOut

var in_game: bool = false
var sequence: Array
var score: int = 0
var current_step: int = 0
var last_sector: Node

func _ready() -> void:
	randomize_sequence()

#
# Intro sequence
#
func _start_game() -> void:
	randomize_colors()
	$TimerSimple.start_timer()
	in_game = true
	n_intro_fadeout.fade_out()

func display_intro(sequnce_keys) -> void:
	for i in range(len(sequnce_keys)):
		var label = n_sequence_display.get_child(i).get_child(0)
		label.text = sequnce_keys[i]
		label.modulate = colors[sequnce_keys[i]]
	
	var re_sequence = sequnce_keys.duplicate()
	re_sequence.shuffle()
	for i in range(len(re_sequence)):
		var node = n_intro_buttons.get_child(i).get_child(0)
		node.get_node("Polygon2D").color = colors[re_sequence[i]]
		node.get_node("HoverEffect").color = Color("#ffffff", 0.6)
		node.get_node("Clickable").onClick.connect(on_button_clicked)

#
# GUI
#
func _process(_delta: float) -> void:
	n_label_score.text = str(score)+"/20"
	n_label_time.text = $TimerSimple.current_time_formatted()
	
#
# Randomization
#
func randomize_sequence() -> void:
	var sequnce_keys = colors.keys()
	sequnce_keys.shuffle()
	display_intro(sequnce_keys)
	sequence = sequnce_keys.map(func(x): return colors[x])

func randomize_colors() -> void:
	polygons.shuffle()
	var i = 0
	for poly in polygons:
		if poly == last_sector:
			poly.color = Color.TRANSPARENT
			continue
		
		if i < len(colors.values()):
			poly.color = colors.values()[i]
		else:
			poly.color = Color.TRANSPARENT
		i+=1

#
# Input
#
func on_sector_selected(sector: Node) -> void:
	last_sector = sector
	if sector.color == Color.TRANSPARENT:
		return
	if not in_game:
		return
	
	if sector.color == sequence[current_step]:
		$SoundCorrect.play()
		current_step += 1
		if current_step >= len(sequence):
			current_step = 0
			score += 1
			n_label_score.get_node("Highlight").highlight()
		if score >= 20:
			on_win()
	else:
		$SoundIncorrect.play()
		n_health_controller.take_damage()
	
	randomize_colors()

func on_button_clicked(button: Node) -> void:
	if in_game:
		return
	
	if button.get_node("Polygon2D").color == sequence[current_step]:
		$SoundCorrect.play()
		current_step += 1
		if current_step >= len(sequence):
			current_step = 0
			_start_game()
	else:
		$SoundIncorrect.play()
		current_step = 0
	
	randomize_colors()
#
# Ending game
#
func on_win() -> void:
	$SoundSuccess.play()
	n_win_screen.show_screen("Your time: "+$TimerSimple.current_time_formatted())

func on_death() -> void:
	$SoundDeath.play()
	n_fail_screen.show_screen("You reached "+str(score)+"/20 correct sequences")
