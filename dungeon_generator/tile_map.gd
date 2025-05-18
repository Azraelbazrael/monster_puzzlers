extends TileMap

var tiles_in_room = [] ##array of tiles
var rand_point
@export var map: map_resource: set = set_map


func _ready() -> void:
	Global.connect("game_over", clear_tiles)
	Global.connect("obj_placed", place_object)


func set_map(Map: map_resource):
	map = Map
	tile_set = map.tileset
	update_map()

func update_map():
	if map is not map_resource:
		return
	if not is_inside_tree():
		await ready	
		
		
func clear_tiles():
	tiles_in_room.clear()


func place_object() -> void:
	if tiles_in_room.is_empty():
		for tile in get_used_cells_by_id(0,0):
			tiles_in_room.append(tile) ##i'll figure something out later, this just puts the endbox on ANY tile the player can int with
	else: 
		pass
	rand_point = tiles_in_room.pick_random()
