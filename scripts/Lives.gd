extends GridContainer

const Life = preload("res://ui/Life.tscn")

var value = 0

func reset(p_value):
	for _i in range(value):
		remove()
	for _i in range(p_value):
		add()

func add():
	add_child(Life.instance())
	value += 1
	
func remove():
	if value > 0:
		get_child(get_child_count() - 1).queue_free()
		value -= 1
