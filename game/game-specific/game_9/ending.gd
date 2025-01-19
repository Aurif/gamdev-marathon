extends G9StoryPoint
class_name G9Ending

static var endings: int = 0
var ending_number: int

var _story: String
var _ending_name: String
func _init(ending_name: String, story: String) -> void:
	endings += 1
	ending_number = endings
	_ending_name = ending_name
	_story = story

func start_ending() -> void:
	QuarkAnchor.get_anchor("ending").visible = true
	QuarkAnchor.get_anchor("ending_story").text = _story
	QuarkAnchor.get_anchor("ending_number").text = "\""+_ending_name+"\" ending ("+str(ending_number)+"/"+str(endings)+")"
