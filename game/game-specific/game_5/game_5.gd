extends Node

@export var polygons: Array[Polygon2D]
@export var colors: Dictionary
@export var n_health_controller: MolHealthController
@export var n_label_score: Label
@export var n_label_time: Label
@export var n_fail_screen: MolFailScreen
@export var n_win_screen: MolWinScreen

var sequence: Array
var score: int = 0
var current_step: int = 0
var last_sector: Node

func _ready() -> void:
	randomize_sequence()
	randomize_colors()
	$TimerSimple.start_timer()

func _process(delta: float) -> void:
	n_label_score.text = str(score)+"/20"
	n_label_time.text = $TimerSimple.current_time_formatted()
	

func randomize_sequence() -> void:
	var sequnce_keys = colors.keys()
	sequnce_keys.shuffle()
	print(sequnce_keys)
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

func on_sector_selected(sector: Node) -> void:
	last_sector = sector
	if sector.color == Color.TRANSPARENT:
		return
	
	if sector.color == sequence[current_step]:
		$SoundCorrect.play()
		current_step += 1
		if current_step >= len(sequence):
			current_step = 0
			score += 1
		if score >= 20:
			on_win()
	else:
		$SoundIncorrect.play()
		n_health_controller.take_damage()
	
	randomize_colors()

func on_win() -> void:
	$SoundSuccess.play()
	n_win_screen.show_screen("Your time: "+$TimerSimple.current_time_formatted())

func on_death() -> void:
	$SoundDeath.play()
	n_fail_screen.show_screen("You reached "+str(score)+"/20 correct sequences")
