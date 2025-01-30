extends Node

@export var sprite_candidates: Array[CompressedTexture2D] = []
@export var n_win_screen: Control
@export var preset_segment: PackedScene

var selected_sprite: CompressedTexture2D
var all_segments = []
var core_segment: Node
var current_selection: int = 0
var won: bool = false

var SEG_COUNT

func _ready() -> void:
	selected_sprite = sprite_candidates.pick_random()
	SEG_COUNT = randi_range(5, 16)
	
	prep_segments.call_deferred()
	change_selection.call_deferred(0)
	
	var timer = get_tree().create_tween().bind_node(self)
	timer.tween_interval(1)
	timer.tween_callback(check_victory)
	timer.set_loops()

func prep_segments() -> void:
	for i in range(SEG_COUNT):
		var node = preset_segment.instantiate()
		node.radius = lerp(500, 64, float(i)/(SEG_COUNT-1))
		node.modulate = Color("#6b6b6b")
		node.get_node("InputMouseRotation").process_mode = Node.PROCESS_MODE_DISABLED
		node.get_node("TextureRect").texture = selected_sprite
		add_child(node)
		if i != SEG_COUNT-1:
			node.rotation = round(randf_range(0, 2*PI)/deg_to_rad(15))*deg_to_rad(15)
			all_segments.append(node)
		else:
			core_segment = node
	current_selection = randi_range(0, SEG_COUNT-2)

func change_selection(delta: int) -> void:
	all_segments[current_selection].modulate = Color("#6b6b6b")
	all_segments[current_selection].get_node("InputMouseRotation").process_mode = Node.PROCESS_MODE_DISABLED
	current_selection = (current_selection+len(all_segments)+delta)%len(all_segments)
	
	var current_node = all_segments[current_selection].get_node("InputMouseRotation")
	all_segments[current_selection].modulate = Color.WHITE
	current_node.process_mode = Node.PROCESS_MODE_INHERIT
	current_node.reset_offset_to_now()
	
func _input(event: InputEvent) -> void:
	if QuarkInput.is_keypress(event, "Q") and not won:
		change_selection(1)
		$SoundClick.play()
	if QuarkInput.is_keypress(event, "E") and not won:
		change_selection(-1)
		$SoundClick.play()
	if QuarkInput.is_keypress(event, "R"):
		get_tree().reload_current_scene()

func check_victory() -> void:
	if won:
		return
	for s in all_segments:
		if int(rad_to_deg(s.rotation)) % 360 != 0:
			return
	
	for s in all_segments:
		s.modulate = Color.WHITE
		s.get_node("InputMouseRotation").process_mode = Node.PROCESS_MODE_DISABLED
	core_segment.modulate = Color.WHITE
	n_win_screen.visible = true
	won = true
	$SoundFanfare.play()
