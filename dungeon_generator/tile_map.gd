extends TileMap

var rand_point
const TILESIZE = 32
@export var map: map_resource: set = set_map


func _ready() -> void:
	tile_set = map.tileset
	Global.connect("obj_placed", place_object)


func set_map(Map: map_resource):
	map = Map
	update_map()

func update_map():
	if map is not map_resource:
		return
	if not is_inside_tree():
		await ready	
		
		



func place_object() -> void:
	var floor_tiles = get_used_cells_by_id(0,0)
	rand_point = floor_tiles.pick_random() 
	#print(get_used_rect())
