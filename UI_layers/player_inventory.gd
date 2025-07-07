extends GridContainer
@onready var p_slot = $Slot
signal item_changed

func equip(item):
	var character_child = get_tree().root.get_node("Character")
	if item !=null:
		if character_child:
			#character_child.weapon.visible = true
			character_child.current_item = item
		else:
			#get_tree().current_scene.get_node("Character").weapon.visible = true
			get_tree().current_scene.get_node("Character").current_item = item
			print(item.name)
	else:
		return
	
##figure out way to remove item from inventory permanently
