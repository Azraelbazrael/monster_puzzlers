<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
</details>


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
<p>read more about <a href="#readme-top">DropData</a> here</p>


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



### Items
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

  
#### Weapon
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
<p>Below is code used on the main tilemaps for dungeon generation. This is located in tile_map.gd.</p>

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

## Main
This section will be covering the main node of the project, encompassing maze generation, file structure and how a level is presented to the player.

## Interactable Items

## Enemies


