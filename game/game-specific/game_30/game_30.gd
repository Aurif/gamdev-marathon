extends Node

@export var answers: Array[Label] = []

signal UpdateQuestion(message: String)
signal UpdateQuestionCounter(message: String)
signal Flash(color: Color, time: float)
signal OnNextQuestion()
signal OnWon(message: String)

var score = 0
var current_question = 0
var in_animation = false
const questions = [
	["The marathon consisted of how many games?", ["27", "30", "32"], 1],
	["How many days were skipped?", ["0", "1", "2"], 0],
	["What was the main color palette of the games?", ["Yellow and purple", "Yellow and blue", "White and black"], 0],
	["How many 3D games were developed?", ["0", "1", "3"], 1],
	["How many games used AI generated graphics?", ["0", "1", "2"], 0],
	["How many games contained pictures of red pandas?", ["0", "1", "2"], 2],
	["On what day was the last game released?", ["07.02", "09.02", "10.02"], 1],
	["Game 29 was about...", ["Walking through a maze", "Solving puzzles", "Bouncing balls"], 0],
	["Game 1 was about...", ["Remembering a sequence", "Bouncing balls", "Quick typing"], 2],
	["Which game took the least amount of time to be developed?", ["Red light, green light", "Hotspot finder", "Don't press the button"], 2],
	["What was the longest development time for a game during the marathon?", ["8h", "10h", "11h"], 2],
	["Which game had a sequel made during the marathon?", ["Don't press the button", "Climber", "Go, Ball, Go!"], 0],
	["Which game had the longest description on gamejolt?", ["The Keypad Breaker", "Storytime", "An idle game"], 0],
	["What type of game was NOT made during the marathon?", ["A puzzle game", "A card game", "A story game"], 1],
	["The projectiles in \"Dodge this!\" were in the shape of what?", ["Bones", "Bricks", "Balls"], 0],
	["In \"Gambling Simulator\" the two cheapest options had...", ["Positive expected value", "Expected value equal 0", "Negative expected value"], 1],
	["In \"Storytime\" one of the endings was...", ["Freezing to death", "Making a mushroom soup", "Finding a huge manor"], 0],
	["The tier 3 tile in \"An idle game\" gave...", ["3@/tick", "7@/tick", "8@/tick"], 2],
	["Which was NOT a button in \"The Keypad Breaker\"?", ["Modulo sum", "Decrease digits by one", "Left-most digit"], 2],
	["The \"Wall-less Maze\" consisted of how many levels?", ["5", "7", "8"], 1],
	["What colors appeared in \"Sequence\"?", ["Purple, orange, red, blue", "Red, blue, green, orange", "Red, blue, yellow, green"], 0],
	["When was \"Purplerooms\" released?", ["Day 3", "Day 15", "Day 29"], 2],
	["When was \"A game about pipes and buttons\" released?", ["Day 7", "Day 12", "Day 22"], 0],
	["When was \"Roto-Puzzle\" released?", ["Day 5", "Day 16", "Day 20"], 2],
	["When was \"Go, Ball, Go!\" released?", ["Day 10", "Day 16", "Day 25"], 1],
	["When was \"Out of orbit\" released?", ["Day 17", "Day 21", "Day 27"], 2],
]

func _ready() -> void:
	mount_answers.call_deferred()
	prep_question.call_deferred()
	

func mount_answers() -> void:
	for a in range(len(answers)):
		answers[a].get_node("Clickable").onClick.connect(answered.bind(a))

func prep_question() -> void:
	UpdateQuestionCounter.emit("Question "+str(current_question+1)+"/"+str(len(questions)))
	var q = questions[current_question]
	UpdateQuestion.emit(q[0])
	for a in range(len(answers)):
		var node = answers[a]
		node.modulate = Color.WHITE
		node.text = q[1][a]
		node.get_node("OnHover").text = q[1][a]

func answered(answer: int) -> void:
	if in_animation:
		return
	in_animation = true
	
	if answer == questions[current_question][2] or questions[current_question][2] == -1:
		score += 1
		$SoundWon.play()
		Flash.emit(Color("#3d663d65"), 0.3)
	else:
		$SoundLost.play()
		Flash.emit(Color("#7826286a"), 0.3)
		
	for a in range(len(answers)):
		var node = answers[a]
		if a == questions[current_question][2]:
			node.modulate = Color("#85ff85")
		elif a == answer:
			node.modulate = Color("#ff696b")
		else:
			node.modulate = Color.TRANSPARENT
		
	get_tree().create_timer(1).timeout.connect(next_question)

func next_question() -> void:
	in_animation = false
	if current_question < len(questions)-1:
		current_question += 1
		OnNextQuestion.emit()
		prep_question()
	else:
		OnWon.emit("Score: "+str(score)+"/"+str(len(questions))+" questions")
