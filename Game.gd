extends Node

onready var scene = $Scene
onready var player = $Scene/Player
onready var susometer = $CanvasLayer/Susometer
onready var lives = $CanvasLayer/Lives
onready var gameover = $CanvasLayer/GameOver
onready var gamewin = $CanvasLayer/GameWin

const last_character = "Bog"
const initial_lives = 1

var _dialog
var _current_character
var _suspicion
var _odds
var _update_suspicion = false

func _ready():
	start_game()

func _process(_delta):
	if _update_suspicion:
		var new_suspicion = float(Dialogic.get_variable('suspicion'))
		if new_suspicion != _suspicion:
			_suspicion = new_suspicion
			susometer.set_value(_suspicion)
			_odds = clamp(1.0 - _suspicion, 0, 1)
			Dialogic.set_variable('odds', _odds * 100.0)

func start_game():
	randomize()
	gamewin.hide()
	gameover.hide()
	susometer.hide()
	player.set_enabled(true)
	lives.reset(initial_lives)
	var _err = Events.connect("player_meet_character", self, "_on_player_meet_character")
	assert(_err == OK)

func do_harvest_cutscene(character):
	var success = randf() <= _odds
	yield(player.do_attack(character), "completed")
	if success:
		yield(character.do_death(), "completed")
		print("Adding a life")
		lives.add()
	else:
		yield(player.do_injury(), "completed")
		print("Removing a life")
		lives.remove()

	print("Remaining lives: %s" % lives.value)
	if lives.value <= 0:
		game_over()

func game_over():
	gameover.show()

func game_win():
	gamewin.show()
	gamewin.get_node("BrainsHarvestedLabel").text = "Brains harvested: %s" % lives.value

func _start_timeline(timeline):
	_dialog = Dialogic.start(timeline)
	_dialog.connect("timeline_end", self, "_on_timeline_ended")
	Dialogic.set_variable("outcome", "spare")
	add_child(_dialog)
	_update_suspicion = true

func _on_timeline_ended(_timeline):
	_update_suspicion = false
	scene.show()
	if Dialogic.get_variable("outcome") == "harvest":
		yield(do_harvest_cutscene(_current_character), "completed")
	else:
		_current_character.queue_free()
	susometer.hide()
	
	if _current_character.character_name == last_character and lives.value >= 0:
		game_win()
		return

	player.set_enabled(true)
	Dialogic.set_variable("outcome", "spare")

func _on_player_meet_character(character):
	_current_character = character
	scene.hide()
	player.set_enabled(false)
	susometer.show()	
	_start_timeline(character.timeline_name)

func _on_restart_game():
	var _err = get_tree().reload_current_scene()
	assert(_err == OK)
