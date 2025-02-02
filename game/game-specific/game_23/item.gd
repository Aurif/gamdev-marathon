extends Control

var tier = 0

func set_tier(new_tier: int) -> void:
	if tier != 0:
		QuarkAnchor.get_anchor("game").unregister_tile(tier)
	QuarkAnchor.get_anchor("game").register_tile(new_tier)
		
	tier = new_tier
	$Label.text = str(tier)
	self.tooltip_text = G23Tiers.TIER_DEFINITIONS[tier].tooltip
