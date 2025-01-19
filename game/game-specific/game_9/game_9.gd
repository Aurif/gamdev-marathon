extends Node

@export var n_text: Node
@export var n_left: Control
@export var n_right: Control
@export var n_up: Control
@export var n_down: Control

@onready var choice_nodes: Array[Control] = [n_left, n_right, n_up, n_down]
var current_choices = []

##
## Story
##
func story() -> void:
	var null_node = G9StoryPoint.new()
	var before_forest = G9StoryPoint.new()
	var path_start = G9StoryPoint.new()
	var ending_reasonable = G9Ending.new("Be reasonable", "You turn back, enter your car and drive home. The forest feels... wrong, especially this time of year. \nWho knows what might have happened to you?")
	
	before_forest \
		.right("Enter the forest", "You push through the shrubbery until you notice a dirt path between the trees.", path_start) \
		.ending_left("Turn back", ending_reasonable)
		
	path_start \
		.left("Go left", "", null_node) \
		.right("Go right", "", null_node) \
		.up("Follow the path", "", null_node) \
		.ending_down("Turn back", ending_reasonable)
		
	# Starting point
	setup_story_point(
		"You find yourself at the edge of an unfamiliar forest. Tall pines rise before you, their branches covered in snow.",
		before_forest
	)

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
