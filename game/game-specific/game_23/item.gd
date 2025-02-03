extends Control
class_name G23Item

var tier = 0

func set_tier(new_tier: int) -> void:
	if tier != 0:
		QuarkAnchor.get_anchor("game").unregister_tile(tier)
	QuarkAnchor.get_anchor("game").register_tile(new_tier)
		
	tier = new_tier
	$Label.text = str(tier)
	update_tooltip()

func _exit_tree():
	if tier != 0:
		QuarkAnchor.get_anchor("game").unregister_tile(tier)

func update_tooltip() -> void:
	self.tooltip_text = G23Tiers.TIER_DEFINITIONS[tier].tooltip.call()
