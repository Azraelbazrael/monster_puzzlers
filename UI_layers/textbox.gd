extends MarginContainer


@onready var end_button: Button = $NinePatchRect/VBoxContainer/Button
@onready var text_label: RichTextLabel = $NinePatchRect/VBoxContainer/RichTextLabel
var game_comp: bool = false
 

func _ready():
	Global.connect("game_over", _on_game_over)
	Global.connect("player_died", _on_player_died)
	text_label.text = "[center]%s[center]" % (str(Global.map_name)+ " Floor:  " + str(Global.current_level + 1))
	end_button.visible = false
	#text_label.bbcode_enabled = true

func _on_game_comp() -> void:
	
	game_comp = true
	text_label.clear()
	text_label.append_text("You've done it! You won")
	end_button.visible = true
	


func _on_game_over() -> void:
	end_button.disabled = false
	end_button.visible = true
	
func _on_player_died() -> void:
	end_button.disabled = false
	end_button.visible = true
	
func _on_button_pressed() -> void:
		end_button.visible = false
		Global.emit_signal("generate_dungeon")
