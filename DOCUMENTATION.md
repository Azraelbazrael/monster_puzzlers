## Important Resources
Resources in Godot 4.4 act as data containers, nodes pull from them in order to do things like hold variables and arrays and lists. The ability to create custom resources is a very valuable tool in the arsenal of any godot dev. <br> In this section, I'll go over the prominent resources I've created and used through out the project and where I've used them to get a better picture of how each part plays into the larger project. 

### Stats
The stats resource class holds components related to the node's it'll be attached to later on. If it's got "health" to speak of, it has data from or inheriting from this resource.  
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
* Type: What type of object has these stats, a player/enemy or chest/rock?
* Max_health: Maximum amount of health
* Art: Sprite2D texture
* Damage: How much an (unarmed) attack will deal upon contact
<br>

The Item Drops group below carries an array of what "Items" the object can "Drop". 
Not all objects with the stats resource attached to them have items that it can drop, this only applies specifically to enemies and chests/rocks.
```sh
@export_group("Item drops")
@export var drops: Array[DropData]
```
<p align="right">(<a href="#readme-top">read more about DropData here</a>)</p>
<br>

If it has health, it can lose health as well. These two functions keep track of both of these. 
```sh
var health: int : set = set_health

func set_health(value : int) -> void:
	health = clampi(value, 0, max_health)
	
func take_damage(damage : int) -> void:
	if damage <= 0:
		return
	self.health -= damage
```

```sh	
func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	return instance
```
### Items

## Signals

## Maze generation


## Position Generation

## Inventory

## State Machines


