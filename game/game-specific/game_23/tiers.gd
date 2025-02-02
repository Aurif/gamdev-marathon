class_name G23Tiers

static var state = {
	"income": DualVar.new(1)
}

class DualVar:
	var permanent: float = 0
	var temporary: float = 0
	
	func _init(perm_value: float = 0):
		permanent = perm_value
	
	func add_permanent(value: float) -> void:
		permanent += value
	
	func add_temporary(value: float) -> void:
		temporary += value
	
	func get_value() -> float:
		return permanent + temporary
		
	func reset() -> void:
		temporary = 0


##
## Tiers
##
static var TIER_DEFINITIONS = {
	1: Tier1
}

class Tier:
	static func calc(amount: int, state: Dictionary) -> void:
		return

class Tier1:
	static var tooltip = "Earn 1@/tick"
	static func calc(amount: int, state: Dictionary) -> void:
		state.income.add_temporary(amount)
