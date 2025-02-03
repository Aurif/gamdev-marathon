extends Node

const SAVE_TIMER = 3

func _ready() -> void:
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_interval(SAVE_TIMER)
	#tween.tween_callback(save)
	tween.set_loops()
	if not QuarkAutosave.SHOULD_INIT:
		return
	load_save()


func save() -> void:
	print("SAVED")
	var packed_scene = PackedScene.new()
	_set_owner(get_tree().current_scene, get_tree().current_scene)
	packed_scene.pack(get_tree().current_scene)
	var err = ResourceSaver.save(packed_scene, "user://savegame.tscn")
	if err != OK:
		print("Save failed: ", err)

func _set_owner(node, root):
	if node != root:
		node.owner = root
	for child in node.get_children():
		_set_owner(child, root)

func load_save() -> void:
	QuarkAutosave.SHOULD_INIT = false
	var packed_scene: PackedScene = ResourceLoader.load("user://savegame.tscn")
	if packed_scene:
		get_tree().current_scene.queue_free()
		load_save_post.call_deferred(packed_scene)

func load_save_post(packed_scene) -> void:
	var loaded_scene = packed_scene.instantiate()
	get_tree().get_root().add_child(loaded_scene)
	get_tree().current_scene = loaded_scene
