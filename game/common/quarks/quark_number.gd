class_name QuarkNumber

static func get_scientific_notation(number: float, precision: int = 99, use_engineering_notation: bool = false) -> String:
	var sign_ = sign(number)
	number = abs(number)
	if number < 1:
		var exp_ = step_decimals(number)
		if use_engineering_notation: exp_ = snapped(exp_ + 1, 3)
		var coeff = sign_ * number * pow(10, exp_)
		return str(snapped(coeff, pow(10, -precision))) + "e" + str(-exp_)
	elif number >= 10:
		var exp_ = str(number).split(".")[0].length() - 1
		if use_engineering_notation: exp_ = snapped(exp_ - 1, 3)
		var coeff = sign_ * number / pow(10, exp_)
		return str(snapped(coeff, pow(10, -precision))) + "e" + str(exp_)
	else:
		return str(snapped(sign_ * number, pow(10, -precision))) + "e0"
		
static func three_significant_digits(number: float) -> String:
	if number >= 100 or int(number) == number:
		return "%.f" % number
	if number >= 10:
		return "%.1f" % number
	return "%.2f" % number

static func format_number(number: float) -> String:
	if number >= 1e15:
		return get_scientific_notation(number, 2)
	if number >= 1e12:
		return three_significant_digits(number/1e12)+"T"
	if number >= 1e9:
		return three_significant_digits(number/1e9)+"B"
	if number >= 1e6:
		return three_significant_digits(number/1e6)+"M"
	if number >= 1e3:
		return three_significant_digits(number/1e3)+"K"
	return three_significant_digits(number)
