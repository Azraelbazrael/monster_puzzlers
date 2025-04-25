extends Node2D
class_name MainNode
## MAIN VARIABLES

var Room = preload("res://dungeon_generator/Room.tscn")
var Player = preload("res://Playable_character/character.tscn")
var font = preload("res://assets/fonts/RobotoBold24.tres")
var evil_rock = preload("res://item_test_scenes/evil_rock.tscn")

@export var Map: TileMap
@onready var screen_layer: CanvasLayer = $ScreenLayers
@onready var textbox: MarginContainer = $ScreenLayers/textbox

var tile_size = 32 ## size of tiles
var num_rooms = 20 ## number of total rooms generated
var min_size = 4 ## min room size in tiles
var max_size = 15 ## max room size in tiles
var h_spread = 2000 ## horizontal spread in pixels
var v_spread =	800 ## vertical spread in pixels

var path: AStar2D ## for Astar pathfinding (corridors)
var start_room = null ## now unused
var end_room = null ## now unused
var play_mode: bool
var player = null
var end_box = null

#var s = null
#var ul = null

var room_positions = [] ## array to store room positions
var corridors = [] ## one corridor per connection

#var start ## now unused
#var end ## now unused


func _ready():
	Global.connect("game_start", _on_game_start)
	Global.connect("game_over", _on_game_over)
	Global.connect("player_died", retry)
	Global.connect("generate_dungeon", make_rooms)
	Global.connect("level_passed", level_proceed)
	
	randomize()
	make_rooms()
	
	
func make_rooms(): ## makes rooms
	for n in $RoomContainer.get_children():
		n.queue_free()
		
	Map = $TileMap ## makes the map take into the placeholder one for now LOL
	textbox.end_button.disabled = true
	
	get_node("Camera2D").enabled = true
	
	
			
	start_room = null

		
	for i in range(num_rooms):
		var pos = Vector2((randi_range(-h_spread, h_spread)),(randi_range(-v_spread, v_spread))) ## chooses random position based on the vertical and horizontal spread
		var r = Room.instantiate()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		r.make_room(pos, Vector2(w,h) * tile_size)
		$RoomContainer.add_child(r) ## adds child to room container
		
	## wait for rooms to stop moving
	await(get_tree().create_timer(1.1).timeout) 
	await get_tree().process_frame
	for room in $RoomContainer.get_children():
			room_positions.append(Vector2(room.position.x, room.position.y))
			
	await get_tree().process_frame

	## generate a minimum standing tree connecting rooms
	
	path = find_mst(room_positions)
	make_map()
		
func _draw():
	##figure out the endbox rect stuff
		
	if play_mode:
		return
		
	for room in $RoomContainer.get_children():
		draw_rect(Rect2(room.position - room.size, room.size * 2), Color(32,228,0), false)
		
	if path:
		for p in path.get_point_ids():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				draw_line(pp,cp,
						  Color(1, 1, 0), 15, true)
		
func _process(_delta):
	queue_redraw()
	
	
func _input(event):
	## have generating a room be reduced to one button press
		
	if event.is_action_pressed('ui_select'): ## space_bar
		
		gen_rand_end_rock()
		
	if event.is_action_pressed('ui_focus_next') && path: ##tab
		player_to_end_room()

#
func find_mst(nodes):
	##prims algorithym
	path = AStar2D.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front()) ##YOU
	## repeat until no more nodes remain
	
	while nodes:
		var min_dist = INF ## min distance so far
		var min_p = null ## tracks position of nodes
		var p = null ## current position
		var p3
		
		## loop through all points in path
		for p1 in path.get_point_ids():
			p3 = path.get_point_position(p1)
			for p2 in nodes:
				if p3.distance_to(p2) < min_dist:
					min_dist = p3.distance_to(p2)
					min_p = p2
					p = p1
					
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(p,n)
		
		## Remove the node from the array so it isn't visited again
		nodes.erase(min_p)
	return path

func make_map():
	##finds start and end rooms
	find_start_room()
	find_end_room()
	print(Global.current_level)
	## creates tilemap based off of the rooms and paths made 
	corridors.clear()
	Map.clear()
	
	## fill tilemap with walls, carve out the shapes with grass tiles
	var full_rect = Rect2()
	
	for room in $RoomContainer.get_children():
		var r = Rect2(room.position-room.size, room.get_node("CollisionShape2D").shape.extents*2)
		full_rect = full_rect.merge(r)

	var top_left = Map.local_to_map(full_rect.position)
	var bottom_right = Map.local_to_map(full_rect.end)
	for x in range(top_left.x,bottom_right.x):
		for y in range(top_left.y,bottom_right.y):
			Map.set_cell(0, Vector2i(x, y), 1, Vector2i(0, 0), 0)
			
			

	for room in $RoomContainer.get_children():
		var s = (room.size/tile_size).floor()
		var ul = (room.position/ tile_size).floor() - s
		for x in range(2, s.x * 2 - 1):
			for y in range(2, s.y * 2 - 1):
				Map.set_cell(0, Vector2i(ul.x + x, ul.y + y), 0, Vector2i(0, 0), 0)#
				#print(Vector2i(ul.x + x, ul.y + y))
		room.collision.disabled = true
		

		var p = path.get_closest_point(room.position) 
		
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				start = Map.local_to_map(Vector2(path.get_point_position(p).x, path.get_point_position(p).y))
				end = Map.local_to_map(Vector2(path.get_point_position(conn).x, path.get_point_position(conn).y))									
				carve_path(start, end)
		corridors.append(p) 
	
	
	if corridors:
		start_playing()	
	
func carve_path(pos1, pos2):

	## carve a path between two different points
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	
	
	if x_diff == 0: 
		x_diff = pow(-1.0, randi() % 2)
	if y_diff == 0: 
		y_diff = pow(-1.0, randi() % 2)
	#
	##choose either y/x or x/y
	var x_y = pos1
	var y_x = pos2
	
	if (randi() % 5) > 0:
		x_y = pos2
		y_x = pos1
		
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cells_terrain_connect(0, [Vector2i(x, y_x.y)], 0, 0)
		Map.set_cells_terrain_connect(0, [Vector2i(x, y_x.y + y_diff)], 0, 0)  # widen the corridor
	
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cells_terrain_connect(0, [Vector2i(x_y.x, y)], 0, 0);
		Map.set_cells_terrain_connect(0, [Vector2i(x_y.x + x_diff, y)], 0, 0)
			
	
func find_start_room():
	var min_x = INF 
	for room in $RoomContainer.get_children():
		if room.position.x < min_x: 
			start_room = room
			min_x = room.position.x


func find_end_room():
	var max_x = -INF
	for room in $RoomContainer.get_children():
		if room.position.x > max_x:
			end_room = room
			max_x = room.position.x
			print(end_room.position/tile_size)

func start_playing():
	Global.emit_signal("game_start")

	player = Player.instantiate()
	Global.emit_signal("obj_placed")
	
	add_child(player)
	player.position = Map.rand_point * 32
	await get_tree().process_frame
	gen_rand_end_rock()
	
	
	
func player_to_end_room():
	player.position = end_box.position



func gen_rand_end_rock():
	Global.emit_signal("obj_placed")
	Global.emit_signal("level_passed")
	
	end_box = evil_rock.instantiate()
	end_box.position = Map.rand_point * 32 

	add_child(end_box)
	#print(end_box.position)


func _on_game_over() -> void:
	play_mode = false
	player.queue_free()
	end_box.queue_free()
	screen_layer.show()
	
func _on_game_start() -> void:
	
	play_mode = true 
	get_node("Camera2D").enabled = false
	screen_layer.hide()
	

func retry() -> void:
	_on_game_over()
	Global.current_level = 0 

func level_proceed() -> void:
	Global.current_level += 1
	

func reset_counter() -> void:
	Global.current_level = 0
