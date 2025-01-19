class_name G9StoryPoint

var _choices = [[], [], [], []]

##
## Construction
##
func left(label: String, story: String, next_point: G9StoryPoint) -> G9StoryPoint:
	_set_choice(0, label, story, next_point)
	return self
	
func right(label: String, story: String, next_point: G9StoryPoint) -> G9StoryPoint:
	_set_choice(1, label, story, next_point)
	return self
	
func up(label: String, story: String, next_point: G9StoryPoint) -> G9StoryPoint:
	_set_choice(2, label, story, next_point)
	return self
	
func down(label: String, story: String, next_point: G9StoryPoint) -> G9StoryPoint:
	_set_choice(3, label, story, next_point)
	return self
	
func ending_left(label: String, ending: G9Ending) -> G9StoryPoint:
	_set_ending(0, label, ending)
	return self
	
func ending_right(label: String, ending: G9Ending) -> G9StoryPoint:
	_set_ending(1, label, ending)
	return self
	
func ending_up(label: String, ending: G9Ending) -> G9StoryPoint:
	_set_ending(2, label, ending)
	return self
	
func ending_down(label: String, ending: G9Ending) -> G9StoryPoint:
	_set_ending(3, label, ending)
	return self

func _set_choice(i: int, label: String, story: String, next_point: G9StoryPoint) -> void:
	_choices[i] = [label, func(): return [story, next_point]]

func _set_ending(i: int, label: String, ending: G9Ending) -> void:
	_choices[i] = [label, func(): return ["", ending]]
##
## Access
##
func get_choices() -> Array:
	return _choices
