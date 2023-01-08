extends Sprite

onready var animator = $AnimationPlayer

export var character_name = ""
export var timeline_name = ""

func _ready():
	pass # Replace with function body.

func _on_area_entered(_area):
	Events.emit_signal("player_meet_character", self)

func do_death():
	animator.play("CharacterDeath")
	yield(animator, "animation_finished")
	queue_free()
