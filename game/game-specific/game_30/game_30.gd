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
	["How many days were skipped?", ["0", "1", "2"], 0]
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
	
	if answer == questions[current_question][2]:
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
