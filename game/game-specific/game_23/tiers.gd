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
	10: Tier10.new(),
	11: Tier11.new(),
	12: Tier12.new(),
	13: Tier13.new(),
	14: Tier14.new(),
	15: Tier15.new(),
	16: Tier16.new(),
	17: Tier17.new(),
	18: Tier18.new(),
	19: Tier19.new(),
	20: Tier20.new()
}

class Tier:
	func tooltip() -> String:
		return ""
	
	func calc(amount: int, state: Dictionary) -> void:
		return
	
	func calc_post(amount: int, state: Dictionary) -> void:
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
		return 1+state.T9Boost.get_value()

class Tier10 extends __TierIncreaseIncome:
	func _get_unit_earnings(state: Dictionary) -> float:
		return 5+state.T9Boost.get_value()

##
## 11-12
##
class __TierMultiplyIncome extends Tier:
	func tooltip() -> String:
		return "Multiply earnings by " + QuarkNumber.format_number(_get_unit_earnings(G23Tiers.get_state())) + ""
		
	func calc_post(amount: int, state: Dictionary) -> void:
		var mult = pow(_get_unit_earnings(state), amount)
		state.income.add_temporary(state.income.get_value()*(mult-1))
		
	func _get_unit_earnings(state: Dictionary) -> float:
		return 1
		
class Tier11 extends __TierMultiplyIncome:
	func _get_unit_earnings(state: Dictionary) -> float:
		return 1.2

class Tier12 extends __TierMultiplyIncome:
	func _get_unit_earnings(state: Dictionary) -> float:
		return 2

##
## 13-16
##
class __TierIncreaseIncreases extends Tier:
	func tooltip() -> String:
		return "Permanently increase power of tiers 9-10 by " + QuarkNumber.format_number(_get_unit_earnings(G23Tiers.get_state())) + "@ every tick"
		
	func execute(amount: int, state: Dictionary) -> void:
		state.T9Boost.add_permanent(amount*_get_unit_earnings(state))
		
	func _get_unit_earnings(state: Dictionary) -> float:
		return 0
		
class Tier13 extends __TierIncreaseIncreases:
	func _get_unit_earnings(state: Dictionary) -> float:
		return 1

class Tier14 extends __TierIncreaseIncreases:
	func _get_unit_earnings(state: Dictionary) -> float:
		return 2

class Tier15 extends __TierIncreaseIncreases:
	func _get_unit_earnings(state: Dictionary) -> float:
		return 4

class Tier16 extends __TierIncreaseIncreases:
	func _get_unit_earnings(state: Dictionary) -> float:
		return 8


##
## 17-20
##
class __TierPermMultiply extends Tier:
	func tooltip() -> String:
		return "Permanently multiplies base income by " + QuarkNumber.format_number(_get_unit_earnings(G23Tiers.get_state())) + " every tick"
		
	func execute(amount: int, state: Dictionary) -> void:
		var mult = pow(_get_unit_earnings(state), amount)
		state.income.add_permanent(state.income.permanent*(mult-1))
		
	func _get_unit_earnings(state: Dictionary) -> float:
		return 1

class Tier17 extends __TierPermMultiply:
	func _get_unit_earnings(state: Dictionary) -> float:
		return 1.1

class Tier18 extends __TierPermMultiply:
	func _get_unit_earnings(state: Dictionary) -> float:
		return 1.2

class Tier19 extends __TierPermMultiply:
	func _get_unit_earnings(state: Dictionary) -> float:
		return 1.4

class Tier20 extends __TierPermMultiply:
	func _get_unit_earnings(state: Dictionary) -> float:
		return 2
