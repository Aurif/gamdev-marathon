extends Node

@export var n_stage_label: Label
@export var n_letter_label: Label
@export var n_timer: MolTimer
@export var n_fail_screen: MolFailScreen
@export var n_win_screen: MolWinScreen

var stage: int = 0
var score: int = 0
var stage_progress: int = 0
var current_char: String = "A"

var first_letter_press = null
#
# Stage definition
#
class StageDefinition:
	static var STAGES = []
	var inner = {}
	func _init(amount: int, letters: String):
		inner.amount = amount
		inner.letters = letters
		
	func timing(start: int, decrease: int, min: int):
		inner.time_start = start
		inner.time_decrease = decrease
		inner.time_min = min
		return self
		
	func with_first(letter: String, time: int):
		inner.first = {
			"letter": letter,
			"time": time
		}
		return self
		
	func make():
		StageDefinition.STAGES.append(inner)

func _init() -> void:
	StageDefinition.STAGES = []
	StageDefinition.new(2, "A") \
		.timing(3000, 0, 3000) \
		.make()

	StageDefinition.new(15, "QWEASD") \
		.timing(3000, 200, 800) \
		.make()

	StageDefinition.new(20, "QWEASDRTFGZXCV") \
		.timing(3000, 100, 750) \
		.with_first("G", 5000) \
		.make()

	StageDefinition.new(30, "QWERTYUIPASDFGHJKLZXCVBNM") \
		.timing(3000, 100, 700) \
		.with_first("P", 5000) \
		.make()

	StageDefinition.new(25, "QWERTYUIPASDFGHJKLZXCVBNM123456789") \
		.timing(3000, 100, 650) \
		.with_first("7", 5000) \
		.make()

	StageDefinition.new(15, "123456789") \
		.timing(1000, 75, 400) \
		.make()

	StageDefinition.new(21, "QWERTYUIPASDFGHJKLZXCVBNM123456789") \
		.timing(3000, 1000, 650) \
		.with_first("B", 5000) \
		.make()

#
# Gameplay handling
#
func _input(ev):
	if ev is not InputEventKey or not ev.pressed or ev.echo:
		return
		
	var keycode = ev.keycode
	if(keycode >= 4194438 and keycode <= 4194447):
		keycode = keycode - 4194390
	
	var is_letter = (65 <= keycode and keycode <= 90);
	var is_number = (48 <= keycode and keycode <= 57);
	if not is_letter and not is_number:
		return
		
	var current_char_unicode = current_char.to_upper().unicode_at(0)
	if stage == 0 and current_char_unicode != keycode:
		return # don't fail at 0th stage
		
	if first_letter_press == null:
		first_letter_press = Time.get_unix_time_from_system()
		
	if current_char_unicode == keycode:
		next_letter()
	else:
		fail_game()

func next_letter():
	# Progression
	score += 1
	stage_progress += 1
	if stage_progress >= StageDefinition.STAGES[stage].amount:
		stage += 1
		stage_progress = 0
		if stage >= len(StageDefinition.STAGES):
			win_game()
			return
		n_stage_label.text = "Stage "+str(stage)
		
	# Pick time and letter
	var current_stage = StageDefinition.STAGES[stage]
	var time = max(current_stage.time_min, current_stage.time_start - current_stage.time_decrease * stage_progress)
	var letter = current_stage.letters[randi() % len(current_stage.letters)]
	
	# Handle `with_first`
	if stage_progress == 0 and current_stage.get("first"):
		print(current_stage.first)
		time = current_stage.first.time
		letter = current_stage.first.letter
	
	# Start round
	current_char = letter
	n_letter_label.text = letter
	n_letter_label.get_child(0).stop()
	n_letter_label.get_child(0).play("OnChange")
	n_timer.start_timer(time, fail_game)

func fail_game():
	n_fail_screen.show_screen("Score: "+str(score)+" (stage "+str(stage)+")")
	queue_free()

func win_game():
	var total_time = Time.get_unix_time_from_system() - first_letter_press
	var formatted_time = "%.3fs" % (float(int(total_time * 1000) % 60000)/1000.0)
	var minutes = int(total_time/60)
	if minutes > 0:
		formatted_time = str(minutes) + "m " + formatted_time
	n_win_screen.show_screen("Your time: "+formatted_time)
	queue_free()
