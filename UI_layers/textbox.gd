extends MarginContainer


@onready var end_button: Button = $NinePatchRect/VBoxContainer/Button

var main
func _ready():
	main = get_tree().current_scene


func _on_button_pressed() -> void:
	if main.has_method("make_rooms"):
		main.make_rooms()
	else:
		main.hide_screenlayer()


func _on_main_game_over() -> void:
	end_button.disabled = false
	
