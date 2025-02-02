extends MolFailScreen
class_name MolWinScreen

func show_screen(message: String = "Congratulations ^^"):
	super(message)
	$SoundFanfare.play()
