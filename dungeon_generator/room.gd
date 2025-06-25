extends RigidBody2D

var size
@onready var collision: CollisionShape2D = $CollisionShape2D

func make_room(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = .5
	s.extents = size
	$CollisionShape2D.shape = s


#func _on_body_entered(body: Node) -> void:
#	if body is TileMap:
#		var tilemap = body as TileMap
	#	var used_cells = tilemap.get_used_cells(0)
	#	for cell_coords in used_cells:
	#		var tile_id = tilemap.get_cell(cell_coords.x, cell_coords.y)
	#		print("Colliding with TileMap. Cell: ", cell_coords, " Tile ID: ", tile_id)
	#if body is TileMap:
	 #   var tilemap = body as TileMap
	  #  var used_cells = tilemap.get_used_cells()
	  #  for cell_coords in used_cells:
		#    var tile_id = tilemap.get_cell(cell_coords.x, cell_coords.y)
		 #   print("Colliding with TileMap. Cell: ", cell_coords, " Tile ID: ", tile_id)
