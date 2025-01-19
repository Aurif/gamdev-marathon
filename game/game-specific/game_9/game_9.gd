extends Node

@export var n_text: Node
@export var n_left: Control
@export var n_right: Control
@export var n_up: Control
@export var n_down: Control

@onready var choice_nodes: Array[Control] = [n_left, n_right, n_up, n_down]
var current_choices = []

## Story conditionals
var saw_boar = false

##
## Story
##
func story() -> void:
	var null_node = G9StoryPoint.new()
	var before_forest = G9StoryPoint.new()
	var path_start = G9StoryPoint.new()
	var boar_encounter = G9StoryPoint.new()
	var boar_running = G9StoryPoint.new()
	var boar_climbing = G9StoryPoint.new()
	var boar_before_fall = G9StoryPoint.new()
	var ending_reasonable = G9Ending.new("Be reasonable", "You turn back, enter your car and drive home. The forest feels... wrong, especially this time of year. \nWho knows what might have happened to you?")
	var ending_boar = G9Ending.new("The boar", "The end is painful, but at least it's quick.")
	var ending_cliff = G9Ending.new("The cliff", "And then it stops.")
	var cliff_ending_sequence = G9EndingSequence.new(ending_cliff)
	
	setup_story_point.call_deferred(
		"You find yourself at the edge of an unfamiliar forest. Tall pines rise before you, their branches covered in snow.",
		before_forest
	)
	
	before_forest \
		.right("Enter the forest", "You push through the shrubbery until you notice a dirt path between the trees.", path_start) \
		.ending_left("Turn back", ending_reasonable)
		
	path_start \
		.left("Go left", "", null_node) \
		.right("Go right", "You turn right and walk for a while. You stop when you spot a pair of glowing eyes in the distance. By your best guess, you are staring at a boar, and the boar is staring at you.", boar_encounter) \
		.condition_right(func(): return not saw_boar) \
		.up("Follow the path", "", null_node) \
		.ending_down("Turn back", ending_reasonable)
		
	boar_encounter \
		.left("Slowly back up", "You calmly and quietly start moving backwards, until you find yourself at the path again. The animal didn't follow you. You sigh with relief, but decide not go back that way.", path_start) \
		.trigger_left(func(): saw_boar = true) \
		.right("Run", "You turn around and start running as fast as you can. Glancing over your shoulder, you see that it was indeed a boar and that it is now gaining on you. Your chances of outrunning it are slim.", boar_running)
	
	boar_running \
		.left("Climb the nearest tree", "You grossly misjudged your agility. Every attempt to climb the tree ends in you slipping and falling back down. The boar will reach you any second now.", boar_climbing) \
		.right("Keep running", "You keep running, your vision getting blurry, until, without warning, you lose the ground underneath your feet.", boar_before_fall)
		
	boar_climbing \
		.ending_left("Fight the boar", ending_boar) \
		.ending_right("Try again", ending_boar)
		
	boar_before_fall \
		.down("You fall.", "You wake up laying on the ground, amidst the cold snow.", cliff_ending_sequence)
	
	cliff_ending_sequence \
		.seq_right("Get up", ["You try getting up, but your muscles don't move.", "Terrified, you try to rise your arm up, but it doesn't even twitch.", "You can't move."]) \
		.seq_left("Shout for help", ["You try shouting, but only a gurgling sound escapes your mouth.", "You try again, but again only gurgling can be heard.", "There is no use."]) \
		.seq_up("Wait", ["You try to remain still, hopefully waiting for someone to come by and help you.", "You wait, but no one comes.", "You wait, but you know no one will come."]) \
		.story(["You notice the blood.", "There is a lot of blood.", "It hurts.", "It hurts so much.", "IT HURTS SO MUCH!!!!!"])

## 
## Setup
##
func _ready() -> void:
	story()
	for i in range(4):
		choice_nodes[i].get_node("Clickable").onClick.connect(_on_choice_picked.bind(i).unbind(1))

##
## Transitions
##
func setup_story_point(story: String, story_point: G9StoryPoint) -> void:
	if story_point is G9Ending:
		story_point.start_ending()
		current_choices = [[], [], [], []]
	else:
		n_text.get_node("Label").text = story
		current_choices = story_point.get_choices()
	
	
	for i in range(4):
		if len(current_choices[i]) == 0:
			choice_nodes[i].visible = false
			continue
		
		choice_nodes[i].visible = true
		choice_nodes[i].get_node("Label").text = current_choices[i][0]

func _on_choice_picked(choice: int) -> void:
	var choice_result = current_choices[choice][1].call()
	setup_story_point(choice_result[0], choice_result[1])
