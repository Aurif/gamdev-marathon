class_name G9StoryPoint

var _choices = [[], [], [], []]
var _conditions = [func(): return true, func(): return true, func(): return true, func(): return true]


##
## Construction
##
func _set_choice(i: int, label: String, story: String, next_point: G9StoryPoint) -> void:
	_choices[i] = [label, func(): return [story, next_point]]

func _set_ending(i: int, label: String, ending: G9Ending) -> void:
	_choices[i] = [label, func(): return ["", ending]]

func _set_condition(i: int, condition: Callable) -> void:
	_conditions[i] = condition
	
func _add_trigger(i: int, trigger: Callable) -> void:
	var prev_func = _choices[i][1]
	_choices[i][1] = func():
		trigger.call()
		return prev_func.call()

##
## Access
##
func get_choices() -> Array:
	var ret = []
	for i in range(4):
		if _conditions[i].call():
			ret.append(_choices[i])
		else:
			ret.append([])
	return ret


##
## Aliases
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
	
	
func condition_left(condition: Callable) -> G9StoryPoint:
	_set_condition(0, condition)
	return self
	
func condition_right(condition: Callable) -> G9StoryPoint:
	_set_condition(1, condition)
	return self
	
func condition_up(condition: Callable) -> G9StoryPoint:
	_set_condition(2, condition)
	return self
	
func condition_down(condition: Callable) -> G9StoryPoint:
	_set_condition(3, condition)
	return self

	
func trigger_left(trigger: Callable) -> G9StoryPoint:
	_add_trigger(0, trigger)
	return self
	
func trigger_right(trigger: Callable) -> G9StoryPoint:
	_add_trigger(1, trigger)
	return self
	
func trigger_up(trigger: Callable) -> G9StoryPoint:
	_add_trigger(2, trigger)
	return self
	
func trigger_down(trigger: Callable) -> G9StoryPoint:
	_add_trigger(3, trigger)
	return self
