extends MolFailScreen
class_name MolWinScreen

func show_screen(message: String):
	super(message)
	$SoundFanfare.play()
