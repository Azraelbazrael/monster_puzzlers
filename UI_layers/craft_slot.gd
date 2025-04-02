class_name Crafting_slot
extends PanelContainer

@export var texture_rect: TextureRect 
@export var item: Item_resource

func _process(_delta):
	var value = item
	if value !=null:
		texture_rect.texture = value.art
	else:
		texture_rect.texture = null

func enable(value = true):
	self.show_behind_parent = value
	return value
	
func check():
	var inventory = get_tree().current_scene.find_child("Inventory_Slots")
	if inventory:
		if item != null:
			return enable(inventory.is_available(item))
