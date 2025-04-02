extends GridContainer

@export var craft: Button
@export var item: Item_resource
var recipe

signal craft_item_chose
##make sure recipe works!! then you can have a little fun with it
		
func _process(delta: float) -> void:
	
	if item:
		var recipe = item.recipe
		craft.icon = item.art
		for i in range(recipe.size()):
			get_child(i).item = recipe[i]
		check()	
	
func check():
	var flag = []
 	
	if recipe:
		for i in range(recipe.size()):
			flag.append(get_child(i).check())
	
		if false not in flag:
			craft.disabled = false


func _on_craft_pressed() -> void:
	craft.disabled = true
	var inventory = get_tree().current_scene.find_child("Inventory_Slots")
 
	for i in recipe:
		inventory.remove_item(i)
	inventory.add_item(item)
