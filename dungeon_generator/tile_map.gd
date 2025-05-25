extends TileMap

#var tiles_in_room = [] ##array of tiles
var rand_point
const TILESIZE = 32
@export var map: map_resource: set = set_map


func _ready() -> void:
	#Global.connect("game_over", clear_tiles)
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
		
		



func place_object() -> void:
	var floor_tiles = get_used_cells_by_id(0,0)
	rand_point = floor_tiles.pick_random() 
