extends VBoxContainer

onready var progress = $Progress

func set_value(value):
	$Tween.interpolate_property(progress, "value",
		progress.value, value * 100,
		0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
