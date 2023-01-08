extends AnimatedSprite

onready var tween = $Tween

export var speed = 500

var _enabled = true

func set_enabled(state):
	_enabled = state

func _process(delta):
	if not _enabled:
		return
	if Input.is_action_pressed("right"):
		position.x += speed * delta

func do_attack(character):
	tween.interpolate_property(self, "position:x",
		position.x, character.position.x, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")

func do_injury():
	tween.interpolate_property($Sprite, "modulate",
		Color(1, 1, 1), Color(1, 0, 0), 0.3,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	tween.interpolate_property($Sprite, "modulate",
		Color(1, 0, 0), Color(1, 1, 1), 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
