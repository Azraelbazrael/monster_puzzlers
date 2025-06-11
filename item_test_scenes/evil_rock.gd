extends Rock
class_name evil_rock

## redo the rocks
func _ready() -> void:
	$Sprite2D.texture = (stats.art)
	
	

func broken_rock():
	Global.emit_signal("game_over")

func _break_rock():
	print("rock hit!")
