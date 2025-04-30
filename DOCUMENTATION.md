
## Video Demos

* [Maze Generation + basic level demo](https://youtu.be/iiFiIZqrvmA)
* [Enemy states demo](https://youtu.be/mJAVivYK1Vc)
* [Item drops demo](https://youtu.be/dtQhh4FrpNI)

  
## Important Resources
Resources in Godot 4.4 act as data containers, nodes pull from them in order to do things like hold variables and arrays and lists. The ability to create custom resources is a very valuable tool in the arsenal of any godot dev. <br> In this section, I'll go over the prominent resources I've created and used through out the project and where I've used them to get a better picture of how each part plays into the larger project. 

### Reoccurring variables
Present in these resources are two types of labels, with the same functions. For brevity's sake, I'll define them before delving deeper.

* **Type**: A type of list holding strings of information, usually what kind of object the resource is attached to.
* **Art**: The short hand for 2D texture, to be grabbed later by the object's script.

### Stats


The stats resource class holds components related to the node's it'll be attached to later on. If it's got "health" to speak of, it has data from or inheriting from this resource.  
<br>
#### Variables
 ```sh
class_name Stats	
extends Resource

enum Type{PLAYER,MONSTER,INTERACTABLE}

@export var type: Type
@export var max_health := 1
@export var art: Texture
@export var damage: float
  ```
The exported variables represent these things as follows:
* **Max_health**: Maximum amount of health
* **Damage**: How much an (unarmed) attack will deal upon contact


#### Export group

```sh
@export_group("Item drops")
@export var drops: Array[DropData]
```
The Item Drops group below carries an array of what "Items" the object can "Drop". 
Not all objects with the stats resource attached to them have items that it can drop, this only applies specifically to enemies and chests/rocks.
<p>read more about <a href="#Dropdata">DropData</a> here</p>


#### Health
```sh
var health: int : set = set_health ## CURRENT health, different from total health

 
func set_health(value : int) -> void:
	health = clampi(value, 0, max_health)
	
func take_damage(damage : int) -> void:
	if damage <= 0:
		return
	self.health -= damage
```
If it has health, it can lose health as well. These two functions keep track of both of these. 
take_damage takes from the health based off of an assigned value when the function is called.


```sh	
func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	return instance
```
<p>By duplicating the resource here, I can instance the data into the scene. This allows it to be modified and used for multiple objects without messing with the original container. When duplicating these stats, the function makes sure the object's health is at the maximum.</p>

#### Player's stats
```sh
class_name Character_stats
extends Stats

@export var max_stamina:= 1
var stamina: int : set = set_stamina

func set_stamina(value : int) -> void:
	stamina = clampi(value, 0, 999)
	
func add_stamina(amount : int) -> void:
	self.stamina += amount
	
func take_damage(damage: int) -> void:
	if damage <= 0:
		return
	super.take_damage(damage)

func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	instance.stamina = max_stamina
	return instance

```
Under a new file, character stats inherits from the stats class and uses most of the same logic.
* amount / damage is determined by a value to be assigned when called
* stamina opperates identically to health, when instanced into a scene both are at their maximum value


```sh
func heal(amount : int) -> void:
	self.health += amount
```
One new function present in the character stats is the addition of healing. It still takes in an amount to be assigned later, but replenishes health opposed to taking damage.


<br>


## Items
Items refers to collectables and weapons the player can interact with and craft. This section talks about the data the items generally hold for future reference. 
<p>Read more about <a href="#interactable-items">Interactable items</a> here.</p>

```sh
enum Type{COLLECTABLE, WEAPON}

@export_group("Item Attributes")
@export var type: Type
@export var art: Texture
@export var name: String
@export var stackable: bool
@export var max_stack: int
@export var animation : String



@export_multiline var item_desc: String
```
* stackable: if the player can hold the same item in one slot
* max_stack: how many of each item can be implemented in a single slot
* animation: item's animation name (if applicable)

  
### Weapon
```sh
@export var cost: int
@export var damage: float
@export var weapon_type: Weapon_type
@export var recipe: Array[Item_resource]
@export var rock_damage: float

func use_cost(char_stats: Character_stats) -> void:
	if cost:
		char_stats.stamina -= cost
```

* **cost**: how much stamina the weapon depletes when the player uses it each time
* **rock_damage**: How much damage does this inflict on chests/rocks as opposed to enemies?
* **recipe**: An array of existing item resources needed in order to craft the object

### Dropdata
```sh
class_name DropData 
extends Resource

@export var item : Item_resource
@export_range( 0, 100, 1, "suffix:%" ) var probability : float = 100
@export_range( 1, 10, 1, "suffix:items" ) var min_amount : int = 1
@export_range( 1, 10, 1, "suffix:items" ) var max_amount : int = 1
```
Mentioned previously, DropData stores data about item drops. 
<br>
This encompasses which item resource this is going to reference, the potential minimum and maximum amounts of items and the probability for an item to show up for more chance.

```sh
func get_drop_count() -> int:
	if randf_range( 0, 100 ) >= probability:
		return 0
	return randi_range( min_amount, max_amount )
```
The `get_drop_count` function underneath the establishing variables runs a check to see if a number rolled is greater than the given probability. 
<br>
If so, return the function, do not proceed. Otherwise, return a new random interger from the established minimum and maximum values.

<br>
<!-- SIGNALS -->

## Signals
In Godot, Signals are little messages emitted in order to indicate something's happening. There are multiple ways a signal could be listened for and used and overall make working within GDscript less of a headache. 

### Global Signals
Godot offers a way to automatically load nodes at the base of your scene globally, making for an easy way to access certain signals without having to define new ones for similar uses. this section overs the following  examples.

```sh
extends Node

signal weapon_changed
signal player_died
signal rock_broken
signal generate_dungeon
signal obj_placed
signal game_start
signal game_over

signal enemy_dead(object) ## currently unused
```
Main.gd acknowledges and listens for these signals in order to preform fuctions when emitted upon startup.
```sh
func _ready():
	Global.connect("game_start", _on_game_start)
	Global.connect("game_over", _on_game_over)
	Global.connect("player_died", retry)
	Global.connect("generate_dungeon", make_rooms)
```

### Position Generation
as a randomly-generated dungeon is created for the level's map, it's important that the items, enemy spawns and player position is generated at random as well. Signals are used to indicate when a new random position needs to be pulled up, opposed to the same position being used multiple times otherwise.
<br>
Below is code used on the main tilemaps for dungeon generation. This is located in `tile_map.gd` and can be seen attached to the tilemap node of the same name.

```sh
extends TileMap

var tiles_in_room = []
var rand_point

	
func _ready() -> void:
	Global.connect("game_over", clear_tiles)
	Global.connect("obj_placed", place_object)


func clear_tiles():
	tiles_in_room.clear()


func place_object() -> void:
	if tiles_in_room.is_empty():
		for tile in get_used_cells_by_id(0,0):
			tiles_in_room.append(tile) ##i'll figure something out later, this just puts the endbox on ANY tile the player can int with
	else: 
		pass
	rand_point = tiles_in_room.pick_random()
```
<p>This block of code also demonstrates that at the end of a level the array containing each position is cleared in order to ensure any one of the items generated isn't put in an impossible positon. Like the comment implies there are some flaws with this system, mainly that I can't control what goes where yet in case I really didn't want something to be some place. </p>


<br>

<!-- MAIN SECTION -->


## Main Scene
I've made sure to name the folder it's stored in `00_main` in order to keep the main scene at the top for ease of access.

<img src="assets/screenshots/Main_structure_screenshot.png">

Opening `main.tscn`, you find it holds the `RoomContainer`, `LevelManager`, `Screenlayers` and `TileMap`. 
<br>
Each of these elements contribute to the "background" elements that keep the game running, like a cog to a larger machine. In this case, some cogs are more polished than others.
I've referenced the `Main.gd` script here and there but this section will disect it's contents more thoroughly.

### Main Node

Some variables present were for testing purposes and have since been commented out. There are still reminants to what these variables refer to within the code, but we'll get there when we get there.

```sh
extends Node2D
class_name MainNode
## MAIN VARIABLES

var Room = preload("res://dungeon_generator/Room.tscn")
var Player = preload("res://Playable_character/character.tscn")
var font = preload("res://assets/fonts/RobotoBold24.tres")
var evil_rock = preload("res://item_test_scenes/evil_rock.tscn")
```
The beginning encompases the preloads. 
* **Room**: Holds the node that'll be instantiated in order to generate dungeons.
* **Player**: Contains the player scene with accompanying HUD
* **Font**: Carries the font resource used for text
* **evil_rock**: is weirdly named but functions as an end point the player meets in order to pass the level. Having this in the scene makes sure the player at least has a vauge goal throughout the prototype.

  
<br> 


```sh
@export var Map: TileMap
@onready var screen_layer: CanvasLayer = $ScreenLayers
@onready var textbox: MarginContainer = $ScreenLayers/textbox

var tile_size = 32 ## size of tiles
var num_rooms = 20 ## number of total rooms generated
var min_size = 4 ## min room size in tiles
var max_size = 15 ## max room size in tiles
var h_spread = 2000 ## horizontal spread in pixels
var v_spread =	800 ## vertical spread in pixels
```
This section covers the specifics of dungeon generating, from how many rooms there are in any given dungeon to the tileset used. This will be replaced with level management things in the future works a pretty solid placeholder.


<br>

```sh
func _ready():
	Global.connect("game_start", _on_game_start)
	Global.connect("game_over", _on_game_over)
	Global.connect("player_died", retry)
	Global.connect("generate_dungeon", make_rooms)
	Global.connect("level_passed", level_proceed)
	
	randomize()
	make_rooms()
```
When ready is called, the function listens for the established global signals and connects them to functions to the bottom of the script. 
<br>
These signals tell the program:
* **Game_start**: hen the level is generated
* **Game_over**: when a level needs to stop
* **Player_Died**: When a player has lost all it's health
* **Generate_dungeon**: to generate a dungeon
* **Level_passed**: to pass to the next level

<br>

```sh
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
```

`_on_game_over` as a function toggles off the play mode and removes the player and rock items from the scene. From there it shows the canvas layer, this conveys to the player that they've passed and presents them with a button to continue. 

<br>

#### Dungeon Generation
How a dungeon is randomly generated is broken down into three steps. 
* Spawning the rooms
* Connecting the rooms
* Filling in the map with tiles.

```sh
func make_rooms(): ## makes rooms
	for n in $RoomContainer.get_children():
		n.queue_free()
		
	Map = $TileMap ## makes the map take into the placeholder one for now LOL
	textbox.end_button.disabled = true
	
	get_node("Camera2D").enabled = true #to view the whole map before the level
	
	
			
	start_room = null ## no longer relevant
```

The function begins by removing any rooms that might've been generated prior, establishing what tilemap will be used, and ensuring that the camera in the native scene can see the full map. The Map variable being more open ended is so the tilemaps can be swapped for different tiles later on in development when new maps and areas are needed.

```sh
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
```
I've commented the uses for the individual strings. Essentially this part takes the established variables into account and spawns rooms based on the v/h spreads and grabs a size based on the min and max values, making them all children under the room container node.
<br>
Because of the room's custom solver bias, this takes a moment to fully settle, thus needing a short pause between generations. This action is usually covered by the canvas screen, apart from inital generation. It takes a moment for the draw function to fully process the rooms all in place, this is a bandaid fix to ensure that the player doesn't have any broken maps where rooms can't be accessed.

```sh
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
```

This function grabs takes the assigned value when called and creates a path between the different points. It tracks the positions of the given value, puts them all into an algorithm and cycles through each point in order to form a path. This creates a more literal path for the player to traverse through from room to room.

```sh
func _draw():
		
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
```
The draw function serves to check where all the room-rects are, drawing a box in each of their places. If this changes, the process function calls for a redraw. Once a path is established for the rooms, the dunction draws the points between each room, creating a line for each.

```sh
func make_map():
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
```
Essentially, this portion of dungeon generation creates the room tiles on the screen. It proccesses the information built up to this point in order to fill in the tiles on the tilemap. Once drawing in the tiles, the function disables the collisions that made sure the boxes spread apart in the first place, ensuring the player can move around within them. Towards the end, `make_map` adds each point to the corridor array, before checking if there's anything in there. 
<br>

```sh
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
```
Path carving is the "corridor" equivalent to map making. What this does is *carve* the *path* for the corridors, setting the cells within the lines to have the player walk through from room to room.
Each corridor is widened, given how the player is currently one tile big, an ideal way to travel shouldn't be a tight squeeze.

<br>
Once all is set, the player's level begins.

#### Playable levels
In order to progress through the dungeons, the player must traverse the map and look for a specific rock to break, revealing the next area. Without proper implementations of enemies or environmental dressing, the following is a very barebones way to present this goal.

```sh
func start_playing():
	Global.emit_signal("game_start")

	player = Player.instantiate()
	Global.emit_signal("obj_placed")
	
	add_child(player)
	player.position = Map.rand_point * 32
	await get_tree().process_frame
	gen_rand_end_rock()
	
	
	
func player_to_end_room(): ##rename this later
	player.position = end_box.position



func gen_rand_end_rock():
	Global.emit_signal("obj_placed")
	Global.emit_signal("level_passed")
	
	end_box = evil_rock.instantiate()
	end_box.position = Map.rand_point * 32 

	add_child(end_box)
	#print(end_box.position)

```
Once the game begins, it emits the game start signal, instantiating the player onto the scene. From there the player's position is determined by the random point held in the `tile_map`*. 
<br>
The "end_rock" is placed on the map soon after, which sends a signal that notifies the rest of the project that a level has been generated. Further along the project, I plan for the objects to be handled elsewhere to better take advantage of the blogal signals and avoid having to instantiate it directly on the map generation.

```sh
func _input(event):
	## have generating a room be reduced to one button press
		
	if event.is_action_pressed('ui_select'): ## space_bar
		
		gen_rand_end_rock()
		
	if event.is_action_pressed('ui_focus_next') && path: ##tab
		player_to_end_room()

```
In order to test the map's random positioning and the ending flags triggers, I've added these inputs in order to save myself the time. 


### Room Nodes
```sh
extends RigidBody2D

var size
@onready var collision: CollisionShape2D = $CollisionShape2D

func make_room(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = 1
	s.extents = size
	$CollisionShape2D.shape = s

```

As a preloaded scene, the Room is somewhat self explanatory. When `make_room` is called, it make the 2D collision shape as a rectangle. The following size and positions is determined by assigned values. Extents is used in place of the size outright to make the rooms more manageable and small.
<br> Each room is instantiated in the main scene as the child of the `RoomContainer`.

### Level Manager

**TBA***



<!-- ITEMS SECTION -->
## Interactable Items
Interactable items refers to the collectables that a player can pick up on their journey, these can be small pieces of loot, ore for crafting. The ptoject handles loose items by having one central pickup item code and changes the sprite texture based on the resource attached to the node via code.
```sh
extends CharacterBody2D
class_name PickableItem

signal picked_up

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var item_data: Item_resource

func _ready() -> void:
	_update_texture()
	if Engine.is_editor_hint():
		return
	area_2d.body_entered.connect(_on_body_entered )
```
`item.gd`'s beginning half begins by establishing a few things, mainly the variables referenced throughout the script. The if statement present checks if the enginge's screen is the editor as opposed to the game and calls the update texture occordingly.

```sh
func _on_body_entered( b ) -> void:
	if b is PlayerCharacter:
		if item_data:
			emit_signal("picked_up")
			visible = false
			b.add_item(item_data)
			queue_free()
	pass	
```
the body entered function listens for the singal in the area 2D to detect if another body has entered the space. Upon this, the if statement checks if the body belongs the the `PlayerCharacter` class. If that requirement is met, it emits the established `picked_up` signal, removes visibility from the sprite and lastly, adds the item to the player's inventory. 

`add_item` function found in the `Character.gd` script:

```sh
func add_item(item):
	var inventory = $CanvasLayer/HUD_elements/BottomContainer/VboxContainer/MarginContainer/Inventory/Slot_Container/Inventory_Slots
	
	if inventory:
		inventory.add_item(item)
```
`add_item` function found in `inventory_slot.gd` script:
```sh
func add_item(item : Item_resource):
	for slot in slots:
		if slot.item == null:
			slot.item = item
			item_changed.emit()
			return
	print("Can't add any more item...")

```
### Items in the Overworld
Items do not currently spawn in the overworld in the main scenes, what's in this section details what's present in the projects test scenes. I felt it's important this game had a specific system where items in the map resources arrays show up and spawn randomly as opposed to having them all plop in individually. The latter is inflexible and cannot work for the type of game this is. 
<br>
```sh
func _physics_process(delta):
	var collision_info = move_and_collide( velocity * delta )
	if collision_info:
		velocity = velocity.bounce( collision_info.get_normal() )
	velocity -= velocity * delta * 4 
	
```

when an enemy drops an item, each item has velocity and bounce to it. This makes sure that the objects are not only not static, but add life to the project.

### Equipping an Item
```sh
class_name Slot
extends PanelContainer
var recipe_handler = null 
@export var texture_rect: TextureRect
@export var item: Item_resource = null:
	set(value):
		item = value
		
		if get_parent().name == "Player_inventory":
			get_parent().equip(item)	
		
			
		if value !=null:
			texture_rect.texture = value.art
		else:
			texture_rect.texture = null
```
In the `slot.gd` script, at the top, the node checks if the parent is the player inventory slot. If not, proceed as usual.

```sh
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
```

The equip function found in the `player_inventory` script takes the information hovered over the panel and passes that infromation along to the player script. I have the function look for the player in the current scene with a variable.

### Inventory
Here we'll be going over functions related to the inventory and crafting system. This covers dragging and dropping items, checking the inventory for recipe requirements and how crafting functions.

```sh
extends GridContainer
@onready var slots = get_children()

```
The above is found in `inventory_slots.gd`. It's worth pointing out that this script is attached to nodes that are the parent of individual slot nodes, acting like a manager of sorts. It's here where the `add_item` function is set up for the inventory. 

```sh
func remove_item(item : Item_resource):
	for slot in slots:
		if slot.item == item:
			slot.item = null
			item_changed.emit()
			return
	print("Item not found...")

```
`remove_item` functions almost identically to `add_item` and serves to remove the items from individual slots or, in the future, discard the item all together. 
You can read more about the way an item is picked up in game <a href="#interactable-items">here</a>.
<br>

```sh
func is_available(item):
	for i in get_children():
		if i.item == item:
			return true
	return false

```
`is_available` serves as a means to return if an item resource is available. It runs through all the children, checks if the child node has the called item_resource attached and proceeds to return a true or false based off of the check.


<!-- ENEMIES SECTION -->
## Enemies
An enemy is an important obstacle for this time of gameplay loop. There is no monster taming without any monsters.
<br>
<img src="assets/screenshots/enemy_structure_screenshot.png">
<br>
above is an example of a basic monster, any following monster should take from this. The root node of this scene contains the script that all monsters inherit from, encompassing damage dealing, damage taking and dying.
```sh
extends CharacterBody2D
class_name EnemyCharacter

signal dead_enemy
signal taking_dmg
var damaged: bool

@export var stats: Stats: set = set_stats
@export var damage_label: PackedScene
@export var hitbox: Area2D
@export var knockback_mod: float = 0.1
#var knockback_modifier

func _ready():
	$Sprite2D.texture = stats.art

func set_stats(value: Stats) -> void:
	stats = value.create_instance()
	update_monster()

func update_monster() -> void:
	if stats is not Stats:
		return
	if not is_inside_tree():
		await ready	
```
The top of the script establishes the following signals:
* **dead_enemy**: When an enemie's Health stat reaches zero
* **taking_dmg**: When an enemy is currently being hit
<br>

```sh

func take_damage(amount):
	emit_signal("taking_dmg")
	stats.take_damage(amount)
	damaged = true
	var damage = damage_label.instantiate()
	
	damage.find_child("Label").text = str(amount)
	damage.position = position
	get_tree().current_scene.add_child(damage)
	damaged = false


func _process(_delta):
	if stats.health == 0: ## flips enemies based on direction
		emit_signal("dead_enemy")
		
	if velocity.x < 0:
			$Sprite2D.flip_h = true

	elif velocity.x > 0:
			$Sprite2D.flip_h = false
```
`take_damage` takes in a variable when called, an amount that's passed to another callable function placed in the stats assigned to the node. From there, the damaged bool is turned on and a label is instantiated onto the scene displaying the damage amount.


<br>

<img src= "asset/screenshots/chaser_structure_screenshot.png">

An individual monster's structure looks a bit different than the base scene's. For one, this scene has an area2D with collision shapes that listen for signals opposed to the just the collision. Along with this, this specific monster has a state machine. This part of the section will cover some of the differences in this node's script before moving onto state machines in depth.

```sh
extends EnemyCharacter
class_name ChaserEnemy


func _on_dead_enemy() -> void:
	self.queue_free()

func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta)



func _on_hurtbox_area_entered(hitbox: Area2D) -> void:
	if hitbox.get_parent().is_in_group("Weapon"):
		knockback(hitbox.get_parent().global_position, hitbox.get_parent().hitbox.damage)
```
Using the established hitbox, when something enters the area2D, it checks if the collision is in the "weapon" group. 
If this is the case, knockback ensues and damage is passed along to the parent node.

### State Machines

```sh
extends Node
@export var initial_state : State

var current_state : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
			
func _process(delta):
	if current_state:
		current_state.Update(delta)

		
func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)
		
		
func on_child_transition(state, new_state_name):
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	current_state = new_state

```
Attached to the `StateMachine` node is a script that manages the child nodes attached to it. This keeps track of the different states the enemy has, what state the enemy is currently in and when to transition between states.

<br>
```sh
func randomize_wander():
	#gonna make a seperate prefab for the idle state and have the chaser a walk along a specific path
	move_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	wander_time = randf_range(1,3)

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	randomize_wander()

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func Physics_Update(delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed
		
	if player:
		var direction = player.global_position - enemy.global_position 
		if direction.length() < 90:
			Transitioned.emit(self,"chase")
```
Above is a very simple idle state. What this does is
* Randomize walking in different directions under a small timer
* Randomize in a different direction when the timer is over
* Check if the *player* is within range, and to switch states under that condition

This is just to "hold down the fort" and doesn't include changing directions when an enemy hits a wall and can cause them to continuously walk into one from time to time.
