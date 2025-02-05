extends Node

@export var n_player: CharacterBody2D
@export var n_platforms: Node2D
@export var preset_platform: PackedScene

##
## Generating platforms
##
const SPAWN_DISTANCE = 800
const MOVE_BY = Vector2(175, 110)
var last_check = 550
var last_pos = Vector2(210, 600)

func _process(_delta: float) -> void:
	if n_player.position.y < last_check+SPAWN_DISTANCE:
		var node = preset_platform.instantiate()
		n_platforms.add_child(node)
		
		var platform_width = diff_platform_width()
		var dir = (MOVE_BY+Vector2(platform_width, 0))*diff_jump_size()*Vector2(randf_range(-1, 1)*4, 1).normalized()
		last_pos.y -= dir.y
		last_check -= dir.y
		if last_pos.x == clamp(last_pos.x+dir.x, 0, 420):
			last_pos.x = clamp(last_pos.x-dir.x, 0, 420)
		else:
			last_pos.x = clamp(last_pos.x+dir.x, 0, 420)
		
		node.scale = Vector2(platform_width/100, 1)
		node.position = last_pos
		node.get_node("AnimatableBody2D").position = Vector2.ZERO
		diff += 1

##
## Deathscreen
##

var mark_for_death = false
signal OnDeath(message: String)
func _physics_process(delta: float) -> void:
	if n_player.velocity.y > 1800:
		mark_for_death = true
	if mark_for_death and n_player.is_on_floor():
		n_player.visible = false
		$SoundSplat.play()
		OnDeath.emit("You reached "+str(diff)+"m")

##
## Difficulty
##
var diff: float = 0
func diff_platform_width() -> float:
	return max(20, 100-(diff/3+sin(pow(diff, 1.1))*sqrt(diff)))

func diff_jump_size() -> float:
	return 0.4+(1-1/pow(diff+1, 0.3))*0.7
