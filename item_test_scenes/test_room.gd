extends TileMap

var tiles_in_room = []
var rand_point
#var rand_point2


func _on_item_test_scene_placed(object: Variant) -> void:
	randomize()	
	if!tiles_in_room:
		for tile in get_used_cells_by_id(0,0):
			tiles_in_room.append(tile)
	rand_point = tiles_in_room[randi() % tiles_in_room.size()]
	print(rand_point)		
