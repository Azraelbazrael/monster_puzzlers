extends MarginContainer


@onready var end_button: Button = $NinePatchRect/VBoxContainer/Button
var game_comp: bool = false

func _ready():
	Global.connect("game_over", _on_game_over)
	Global.connect("player_died", _on_player_died)
	

func _on_game_comp() -> void:
	game_comp = true
	end_button.disabled = true
	

func _on_game_over() -> void:
	end_button.disabled = false
	
func _on_player_died() -> void:
	end_button.disabled = false

func _on_button_pressed() -> void:
	if game_comp == true:
		pass
	else:
		Global.emit_signal("generate_dungeon")
