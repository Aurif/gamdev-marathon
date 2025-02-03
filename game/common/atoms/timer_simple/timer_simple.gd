extends Node
class_name AtomTimerSimple

var _timer_start

func start_timer() -> void:
	if _timer_start == null:
		_timer_start = Time.get_unix_time_from_system()

func current_time() -> float:
	if _timer_start == null:
		return 0.0
	return Time.get_unix_time_from_system() - _timer_start
	
func current_time_formatted() -> String:
	var total_time = current_time()

	var hours   = int(total_time / 3600)
	var minutes = int(total_time / 60) % 60
	var seconds = float(int(total_time * 1000) % 60000) / 1000.0

	var formatted_time = ""

	# If there are hours, always pad minutes to two digits.
	if hours > 0:
		formatted_time += str(hours) + "h "
		formatted_time += "%02d" % minutes + "m "
		formatted_time += "%05.2f" % seconds + "s"
	elif minutes > 0:
		formatted_time += str(minutes) + "m "
		formatted_time += "%05.2f" % seconds + "s"
	else:
		formatted_time += "%.2f" % seconds + "s"
	
	return formatted_time.strip_edges()
