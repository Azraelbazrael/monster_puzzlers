class_name Hud_UI
extends VBoxContainer

@export var stam_bar: TextureProgressBar
@export var hp_bar: TextureProgressBar
	
@export var min_sp: Label
@export var max_sp: Label
	
@export var min_hp: Label
@export var max_hp: Label

func update_stats(stats: Character_stats):

	
	##okay i see the inherent flaw in how i structured this. preload all these variables.
	##this'll go for other stuff too later 
	
	min_hp.text = str(stats.health)
	max_hp.text = str(stats.max_health)
	
	min_sp.text = str(stats.stamina)
	max_sp.text = str(stats.max_stamina)
	
	stam_bar.max_value = (stats.max_stamina)
	stam_bar.value = (stats.stamina)
	
	hp_bar.max_value = (stats.max_health)
	hp_bar.value = (stats.health)


func _on_inv_button_pressed() -> void:
	#print("wsg")
	var craft_bag = $recipe_canvas
	
	if !craft_bag.is_visible():
		craft_bag.show()
	else:
		craft_bag.hide()
