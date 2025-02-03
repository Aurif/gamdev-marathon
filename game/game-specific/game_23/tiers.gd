class_name G23Tiers

static func get_state() -> Dictionary:
	return QuarkAnchor.get_anchor("game").state

##
## Tiers
##
static var TIER_DEFINITIONS = {
	1: Tier1.new(),
	2: Tier2.new(),
	3: Tier3.new(),
	4: Tier4.new(),
	5: Tier5.new(),
	6: Tier6.new(),
	7: Tier7.new(),
	8: Tier8.new(),
	9: Tier9.new(),
	10: Tier10.new()
}

class Tier:
	func tooltip() -> String:
		return ""
	
	func calc(amount: int, state: Dictionary) -> void:
		return
	
	func execute(amount: int, state: Dictionary) -> void:
		return

##
## 1-4
##
class __TierFlatMoney extends Tier:
	func tooltip() -> String:
		return "Earn " + QuarkNumber.format_number(_get_unit_earnings(G23Tiers.get_state())) + "@/tick"
		
	func calc(amount: int, state: Dictionary) -> void:
		state.income.add_temporary(amount*_get_unit_earnings(state))
		
	func _get_unit_earnings(state: Dictionary) -> float:
		return 0
		
class Tier1 extends __TierFlatMoney:
	func _get_unit_earnings(state: Dictionary) -> float:
		return 1+state.T1Boost.get_value()

class Tier2 extends __TierFlatMoney:
	func _get_unit_earnings(state: Dictionary) -> float:
		return 3+state.T2Boost.get_value()
		
class Tier3 extends __TierFlatMoney:
	func _get_unit_earnings(state: Dictionary) -> float:
		return 8+state.T3Boost.get_value()
		
class Tier4 extends __TierFlatMoney:
	func _get_unit_earnings(state: Dictionary) -> float:
		return 16+state.T4Boost.get_value()

##
## 5-8
##
class Tier5 extends Tier:
	func tooltip() -> String:
		return "Increase tier 1-4 earnings by 1@"
	
	func calc(amount: int, state: Dictionary) -> void:
		state.T1Boost.add_temporary(amount)
		state.T2Boost.add_temporary(amount)
		state.T3Boost.add_temporary(amount)
		state.T4Boost.add_temporary(amount)

class Tier6 extends Tier:
	func tooltip() -> String:
		return "Increase tier 1-3 earnings by 4@"
	
	func calc(amount: int, state: Dictionary) -> void:
		state.T1Boost.add_temporary(amount*4)
		state.T2Boost.add_temporary(amount*4)
		state.T3Boost.add_temporary(amount*4)

class Tier7 extends Tier:
	func tooltip() -> String:
		return "Increase tier 1-2 earnings by 12@"
	
	func calc(amount: int, state: Dictionary) -> void:
		state.T1Boost.add_temporary(amount*12)
		state.T2Boost.add_temporary(amount*12)

class Tier8 extends Tier:
	func tooltip() -> String:
		return "Increase tier 1 earnings by 40@"
	
	func calc(amount: int, state: Dictionary) -> void:
		state.T1Boost.add_temporary(amount*40)

##
## 9-10
##
class __TierIncreaseIncome extends Tier:
	func tooltip() -> String:
		return "Permanently increase base earnings by " + QuarkNumber.format_number(_get_unit_earnings(G23Tiers.get_state())) + "@ every tick"
		
	func execute(amount: int, state: Dictionary) -> void:
		state.income.add_permanent(amount*_get_unit_earnings(state))
		
	func _get_unit_earnings(state: Dictionary) -> float:
		return 0
		
class Tier9 extends __TierIncreaseIncome:
	func _get_unit_earnings(state: Dictionary) -> float:
		return 1

class Tier10 extends __TierIncreaseIncome:
	func _get_unit_earnings(state: Dictionary) -> float:
		return 5
