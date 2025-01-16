extends TextureRect
class_name MolWaveFunctionBackground

@export var size_core: int = 1
@export var size_margin: int = 1
@export var target_size: Vector2i

var pattern_map: Dictionary

func _ready() -> void:
	pattern_map = extract_pattern_map(texture.get_image())
	var new_img = Image.create_empty(target_size.x, target_size.y, false, Image.FORMAT_RGBA8)
	ImageFillWorker \
		.new(new_img, decode_color, pattern_map, size_core, size_margin) \
		.with_debug() \
		.fill()
	self.texture = ImageTexture.create_from_image(new_img)

##
## Background generation
##
class ImageFillWorker:
	var img: Image
	var filled: Dictionary = {}
	var in_betweens: Dictionary = {}
	# Godot won't like it otherwise
	var decode_color: Callable 
	var pattern_map: Array
	var size_core: int
	var size_margin: int
	var on_debug: bool = false
	
	func _init(img: Image, decode_color: Callable, pattern_map: Dictionary, size_core: int, size_margin: int):
		self.img = img
		self.decode_color = decode_color
		self.pattern_map = pattern_map.keys()
		self.size_core = size_core
		self.size_margin = size_margin
	
	func with_debug() -> ImageFillWorker:
		on_debug = true
		return self
	
	func fill() -> void:
		fill_pixel_area(
			0, 0,
			pattern_map.pick_random()[1]
		)
		
		var i = 0
		while len(in_betweens) > 0:
			if on_debug:
				img.save_png("debug/tick_" + str(i) + ".png")
				i += 1
				if not collapse_lowest_entropy():
					break
			else:
				collapse_lowest_entropy()
		
	func fill_pixel_area(x: int, y: int, pattern: Array[int]) -> void:
		for yi in range(size_core):
			for xi in range(size_core):
				var color_code = pattern[xi+yi*size_core]
				filled[[x+xi, y+yi]] = color_code
				in_betweens.erase([x+xi, y+yi])
				img.set_pixel(x+xi, y+yi, self.decode_color.call(color_code))
		
		for pixel in get_neighbours(x, y):
			update_pixel(pixel.x, pixel.y)
	
	func collapse_lowest_entropy() -> bool:
		var min_pixel = null
		var min_count = len(pattern_map)+1
		for pixel in in_betweens:
			var entropy = len(in_betweens[pixel])
			if entropy < min_count:
				min_pixel = pixel
				min_count = entropy
				
		if min_pixel != null:
			return collapse_pixel(min_pixel[0], min_pixel[1])
		return false
	
	func collapse_pixel(x: int, y: int) -> bool:
		var valid_patterns = in_betweens.get([x, y], pattern_map)
		if len(valid_patterns) == 0:
			push_error("Wave function pattern failed to converge, filling with random color")
			if on_debug:
				fill_pixel_area(x, y, [-2])
			else:
				fill_pixel_area(x, y, pattern_map.pick_random()[1])
			return false
		
		fill_pixel_area(x, y, valid_patterns.pick_random()[1])
		return true
	
	func update_pixel(x: int, y: int) -> void:
		if filled.get([x, y], -1) != -1:
			return
		var patterns_to_check = in_betweens.get([x, y], pattern_map)
		var patterns_valid = []
		for p in patterns_to_check:
			if check_pattern_matching(x, y, p[0]):
				patterns_valid.append(p)
		in_betweens[[x, y]] = patterns_valid
	
	func check_pattern_matching(x: int, y: int, pattern: Array[int]) -> bool:
		for yi in range(size_core+2*size_margin):
			for xi in range(size_core+2*size_margin):
				var yp = y+yi-size_margin
				var xp = x+xi-size_margin
				
				if not is_in_bounds(xp, yp):
					continue
				var expected_color_code = pattern[xi+yi*(size_core+2*size_margin)]
				
				if filled.get([xp, yp], -1) == -1 or expected_color_code == -1:
					continue
				if expected_color_code != filled[[xp, yp]]:
					return false
		return true
				
	func get_neighbours(x: int, y: int) -> Array[Vector2i]:
		var result: Array[Vector2i] = []
		var norm_size_margin = ceil(float(size_margin)/float(size_core))*size_core
		for yi in range(-norm_size_margin, norm_size_margin+size_core, size_core):
			for xi in range(-norm_size_margin, norm_size_margin+size_core, size_core):
				if (xi >= 0 and xi < size_core) and (yi >= 0 and yi < size_core):
					continue
				if not is_in_bounds(x+xi, y+yi):
					continue
				if filled.get([x+xi, y+yi], -1) != -1:
					continue
				result.append(Vector2i(x+xi, y+yi))
		return result
		
	func is_in_bounds(x: int, y: int) -> bool:
		return not (x<0 or x>=img.get_width() or y<0 or y>=img.get_height())
##
## Pattern extraction
##
func extract_pattern_map(img: Image) -> Dictionary:
	var pattern_map = {}
	for y in range(size_margin, img.get_height()-size_margin-size_core+1):
		for x in range(size_margin, img.get_width()-size_margin-size_core+1):
			var margin = extract_margin(img, x, y)
			var core = extract_core(img, x, y)
			pattern_map[[margin, core]] = true
	return pattern_map

func extract_margin(img: Image, x: int, y: int) -> Array[int]:
	var result: Array[int] = []
	for yi in range(-size_margin, size_margin+size_core):
		for xi in range(-size_margin, size_margin+size_core):
			if (xi >= 0 and xi < size_core) and (yi >= 0 and yi < size_core):
				result.append(-1)
			else:
				result.append(encode_color(img.get_pixel(x+xi, y+yi)))
	return result

func extract_core(img: Image, x: int, y: int) -> Array[int]:
	var result: Array[int] = []
	for yi in range(size_core):
		for xi in range(size_core):
			result.append(encode_color(img.get_pixel(x+xi, y+yi)))
	return result

##
## Color handling
##
var color_encoding: Dictionary = {}
var reverse_color_encoding: Dictionary = {-2: Color.RED}
func encode_color(color: Color) -> int:
	if not color_encoding.has(color):
		color_encoding[color] = len(color_encoding)
		reverse_color_encoding[color_encoding[color]] = color
	return color_encoding[color]

func decode_color(color_code: int) -> Color:
	return reverse_color_encoding[color_code]
