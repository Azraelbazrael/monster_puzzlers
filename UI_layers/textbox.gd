extends MarginContainer


@onready var end_button: Button = $NinePatchRect/VBoxContainer/Button

func _ready():
	Global.connect("game_over", _on_game_over)



func _on_game_over() -> void:
	end_button.disabled = false
	


func _on_button_pressed() -> void:
	Global.emit_signal("generate_dungeon")
