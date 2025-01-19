extends G9StoryPoint
class_name G9EndingSequence

var _ending: G9Ending
var _story_sequence = [[], [], [], []]
var _story_count = [0, 0, 0, 0]
var _total_count = 0
var _max_story_count = 0
var _story = []

func _init(ending: G9Ending) -> void:
	_ending = ending
	
func story(story: Array[String]) -> G9EndingSequence:
	_story = story
	return self

func _set_choice_sequence(i: int, label: String, story: Array[String]) -> void:
	_story_sequence[i] = story
	if len(story) > _max_story_count:
		_max_story_count = len(story)
	
	_choices[i] = [label, func(): 
		if _total_count >= _max_story_count:
			var ind = _total_count-_max_story_count
			print(_total_count, " ", _max_story_count, " ", ind, " ", len(story))
			if ind >= len(_story):
				return ["", _ending]
			
			_total_count += 1
			return [_story[ind], self]
		
		var this_story = _story_sequence[i][min(len(_story_sequence[i])-1, _story_count[i])]
		_story_count[i] += 1
		_total_count += 1
		return [this_story, self]
	]

##
## Aliases
##
func seq_left(label: String, story: Array[String]) -> G9EndingSequence:
	_set_choice_sequence(0, label, story)
	return self
	
func seq_right(label: String, story: Array[String]) -> G9EndingSequence:
	_set_choice_sequence(1, label, story)
	return self
	
func seq_up(label: String, story: Array[String]) -> G9EndingSequence:
	_set_choice_sequence(2, label, story)
	return self
	
func seq_down(label: String, story: Array[String]) -> G9EndingSequence:
	_set_choice_sequence(3, label, story)
	return self
