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
	
	text.text = "[center]%s[center]" % (str(Global.map_name)+ " Floor:  " + str(Global.current_level + 1))
	

func restart():
	self.show()
	text.text = "[center]%s[center]" % ("You perished!")
