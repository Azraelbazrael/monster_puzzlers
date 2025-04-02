extends GridContainer

signal item_changed

func equip(item):
	var character_child = get_tree().current_scene.get_node("Character")
	if item !=null:
		if character_child:
			character_child.current_item = item
		else:
			get_tree().current_scene.current_item = item
			print(item.name)
	else:
		character_child.remove_child(character_child.current_weapon)
		character_child.current_item = null
		return
	
