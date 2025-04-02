extends MarginContainer
#@onready var recipe = item.recipe

func _on_inventory_slots_item_changed() -> void:
	for recipe in get_children():
		recipe.check()
