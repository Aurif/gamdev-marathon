class_name QuarkDebug

static var DEBUG = false

static func random_color() -> Color:
	return Color.from_hsv(
		randf(), 
		[0.5, 0.7, 0.85, 1.0].pick_random(), 
		[0.3, 0.5, 0.7].pick_random()
	)
