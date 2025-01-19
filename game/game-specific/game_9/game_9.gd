extends Node

@export var n_text: Node
@export var n_left: Control
@export var n_right: Control
@export var n_up: Control
@export var n_down: Control

@onready var choice_nodes: Array[Control] = [n_left, n_right, n_up, n_down]
var current_choices = [[], [], [], []]

## Story conditionals
var saw_boar = false
var animating = false

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
	var lost_start = G9StoryPoint.new()
	var lost_no_choice = G9StoryPoint.new()
	var lost_last_breath = G9StoryPoint.new()
	var ending_reasonable = G9Ending.new("Be reasonable", "You turn back, enter your car and drive home. The forest feels... wrong, especially this time of year. \nWho knows what might have happened to you?")
	var ending_boar = G9Ending.new("The boar", "The end is painful, but at least it's quick.")
	var ending_cliff = G9Ending.new("The cliff", "And then it stops.")
	var ending_night = G9Ending.new("The night", "")
	var cliff_ending_sequence = G9EndingSequence.new(ending_cliff)
	var lost_getting_tired = G9EndingSequence.new(lost_no_choice)
	var lost_wandering = G9EndingSequence.new(lost_getting_tired)
	var lost_dying = G9EndingSequence.new(lost_last_breath)
	
	var path_crossroads = G9StoryPoint.new()
	var mushroom_clearing = G9StoryPoint.new()
	var mushroom_look = G9StoryPoint.new()
	var sword_sign = G9StoryPoint.new()
	var sword_closer = G9StoryPoint.new()
	var sword_decision = G9StoryPoint.new()
	var sword_question = G9StoryPoint.new()
	var sword_second_question = G9StoryPoint.new()
	var poster = G9StoryPoint.new()
	var poster_second = G9StoryPoint.new()
	var sword_confusion = G9EndingSequence.new(sword_question)
	var ending_mushroom = G9Ending.new("The mushrooms", "You pick up some mushrooms, carefully selecting only those that look edible. You go back to your car and drive home, happy that you completed your goal so quickly. This is what you came here for, right?\nRight?")
	var ending_sword = G9Ending.new("The motives", "You scream for you don't know.")
	
	
	instant_setup_story_point.call_deferred(
		"You find yourself at the edge of an unfamiliar forest. Tall pines rise before you, their branches covered in snow.",
		before_forest
	)
	
	before_forest \
		.right("Enter the forest", "You push through the shrubbery until you notice a dirt path between the trees.", path_start) \
		.ending_down("Turn back", ending_reasonable)
		
	path_start \
		.left("Go left", "You veer off to the left. Despite walking for what feels like ages, all you can see are the seemingly endless trees.", lost_start) \
		.right("Go right", "You turn right and walk for a while. You stop when you spot a pair of glowing eyes in the distance. By your best guess, you are staring at a boar, and the boar is staring at you.", boar_encounter) \
		.condition_right(func(): return not saw_boar) \
		.up("Follow the path", "You follow the path, enjoying the serene calmness of strolling alone through the forest in the middle of the winter. You continue like that, lost in your thoughts, until you are at the crossroads with another path ahead.", path_crossroads) \
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

	lost_start \
		.right("Go back", "You turn back and head to the path, finding your way without much trouble.", path_start) \
		.left("Push further", "You continue heading straight, pushing deeper into the forest.", lost_wandering)
		
	lost_wandering \
		.seq_right("Go back", ["You decide to turn back onto the path. Step after step, the forest stretches on. Are you sure this is the right way?", "You try to find you way back. The trees are all starting to look the same, and you are losing your sense of direction.", "Your attempts are futile, you are lost."]) \
		.seq_left("Push further", ["You push further into the unknown, hoping to find that what you came here for.", "You keep going through the endless sea of trees, but you can't seem to get anywhere.", "But your stubborness takes over, and so you continue moving forward."]) \
		.story(["It's getting dark.", "It's getting cold.", "You are getting tired."])
	
	lost_getting_tired \
		.seq_right("Go back", []) \
		.seq_left("Push further", []) \
		.story(["You keep on walking, hoping to get somewhere.", "But your pace is getting slower.", "And it is getting harder to move.", "Until you can't walk no more."]) \
		.down("Sit down", "You sit down under one of the trees, freezing from the snow underneath you.", lost_dying)
	
	lost_no_choice \
		.down("Sit down", "You sit down under one of the trees, freezing from the snow underneath you.", lost_dying)
	
	lost_dying \
		.seq_right("Rest", []) \
		.story(["The cold claws relentlessly at your skin.", "You are exhausted.", "Your fingers become numb.", "You are lonely.", "You can't feel your face anymore.", "How you wish someone was with you right now.", "It's getting hard to breathe.", "You know what comes next.", "You look into the starry night one last time."])
		
	lost_last_breath \
		.ending_right("And then you close your eyes.", ending_night)
	
	path_crossroads \
		.left("Go left", "You turn left and follow the path. After a short walk, the path ends and you find yourself in a middle of a small clearing.", mushroom_clearing) \
		.right("Go right", "You turn right and follow the path. It doesn't take long until it ends. There seem to be some kind of poster plastered across one of the trees, but there isn't anything more than that.", poster) \
		.up("Go forward", "You keep heading forward, until a warning sign blocks your way.", sword_sign)
	
	mushroom_clearing \
		.right("Go back", "You walk back the same way you came, until you are at the crossroads again.", path_crossroads) \
		.left("Push further", "Despite the path's abrupt end, you continue heading straight, pushing deeper into the forest.", lost_wandering) \
		.down("Look around", "You look around you, but all you can see are some mushrooms peeking through the snow.", mushroom_look)
	
	mushroom_look \
		.right("Go back", "You walk back the same way you came, until you are at the crossroads again.", path_crossroads) \
		.left("Push further", "Despite the path's abrupt end, you continue heading straight, pushing deeper into the forest.", lost_wandering) \
		.ending_down("Collect mushrooms", ending_mushroom)
	
	sword_sign \
		.up("Go around it", "You go around the sign, and continue heading in the same direction until a bizarre sight appears before you - a sword, half-buried in a massive rock.", sword_closer) \
		.down("Go back", "You walk back the same way you came, until you are at the crossroads again.", path_crossroads)
		
	sword_closer \
		.right("Come closer", "This is what you came here for. This is how you are going to save your life.", sword_decision)
		
	sword_decision \
		.left("Go back", "You try going back, but after walking for a while you somehow end up back near the sword.", sword_decision) \
		.right("Pick up the sword", "You try reaching for the sword, but as your hand touches the handle it turns into a mere branch, just like the many laying around.", sword_confusion)
		
	sword_confusion \
		.seq_right("Look around", ["You frantically start looking around you, hoping the sword is still here somewhere."]) \
		.seq_left("Go forward", ["You keep moving forward, not letting this unusual occurence get to your head."]) \
		.story(["Wait.", "How did you get here?", "What are you doing alone in the forest?", "Why are you here?"])
		
	sword_question \
		.right("I don't know", "WHY ARE YOU HERE?!", sword_second_question)
		
	sword_second_question \
		.ending_right("Scream", ending_sword)
		
	poster \
		.right("Look closer", "Turns out it wasn't a poster, just a piece of paper in a protective plastic. All it says is \"DO NOT EAT THE MUSHROOMS\".", poster_second) \
		.left("Go back", "You walk back the same way you came, until you are at the crossroads again.", path_crossroads)
		
	poster_second \
		.left("Go back", "You walk back the same way you came, until you are at the crossroads again.", path_crossroads)
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
func instant_setup_story_point(story: String, story_point: G9StoryPoint) -> void:
	if story_point is G9Ending:
		story_point.start_ending()
		current_choices = [[], [], [], []]
	else:
		n_text.get_node("Label").text = story
		current_choices = story_point.get_choices()
	
	
	for i in range(4):
		if len(current_choices[i]) == 0:
			choice_nodes[i].visible = false
			choice_nodes[i].modulate = Color.TRANSPARENT
			continue
		
		choice_nodes[i].visible = true
		choice_nodes[i].get_node("Label").text = current_choices[i][0]
		
func setup_story_point(story: String, story_point: G9StoryPoint, previous_choice: int = -1, SPEED: float = 0.8) -> void:
	if story_point is G9Ending:
		story_point.start_ending()
		current_choices = [[], [], [], []]
		return
		
	animating = true
	for i in range(4):
		if len(current_choices[i]) == 0:
			continue 
		var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE)
		if previous_choice == i:
			tween.tween_interval(SPEED*0.8)
			tween.tween_property(choice_nodes[i], "modulate", Color.TRANSPARENT, SPEED/2)
		else:
			tween.tween_property(choice_nodes[i], "modulate", Color.TRANSPARENT, SPEED)
		tween.tween_property(choice_nodes[i], "visible", false, 0)
	
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE)
	tween.tween_property(n_text, "modulate", Color.TRANSPARENT, SPEED)
	tween.tween_interval(SPEED*0.8)
	tween.tween_property(n_text.get_node("Label"), "text", story, 0)
	tween.tween_property(n_text, "modulate", Color.WHITE, SPEED)
	tween.set_parallel(true)
	
	current_choices = story_point.get_choices()
	for i in range(4):
		if len(current_choices[i]) == 0:
			continue
		tween.tween_property(choice_nodes[i], "modulate", Color.WHITE, SPEED)
		tween.tween_property(choice_nodes[i], "visible", true, 0)
		tween.tween_property(choice_nodes[i].get_node("Label"), "text", current_choices[i][0], 0)
	tween.chain().tween_callback(func(): animating = false)

func _on_choice_picked(choice: int) -> void:
	if animating:
		return
	var choice_result = current_choices[choice][1].call()
	setup_story_point(choice_result[0], choice_result[1], choice)
