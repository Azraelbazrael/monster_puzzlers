extends CanvasLayer
@export var text: RichTextLabel
##BLUH! REWRITE!!

func _ready() -> void:
	Global.connect("game_over", game_over)
	Global.connect("game_start", game_start)
	Global.connect("player_died", restart)
	
func game_start():
	self.hide()
	
func game_over():
	self.show()
	text.text = "[center] You won!"
	

func restart():
	self.show()
	text.text = "[center] Try again?"
