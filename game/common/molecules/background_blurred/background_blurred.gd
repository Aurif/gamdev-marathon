extends TextureRect
class_name MolBackgroundBlurred

func set_img(img: Image) -> void:
	var new_image = Image.new()
	new_image.copy_from(img)
	new_image.resize(img.get_size().x/60, img.get_size().y/60, Image.INTERPOLATE_LANCZOS)
	new_image.resize(img.get_size().x, img.get_size().y, Image.INTERPOLATE_LANCZOS)
	self.texture = ImageTexture.create_from_image(new_image)
	
