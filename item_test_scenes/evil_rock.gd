extends rock
class_name evil_rock
	
func broken_rock():
	Global.emit_signal("game_over")
