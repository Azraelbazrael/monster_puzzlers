<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
</details>


## Important Resources
Resources in Godot 4.4 act as data containers, nodes pull from them in order to do things like hold variables and arrays and lists. The ability to create custom resources is a very valuable tool in the arsenal of any godot dev. <br> In this section, I'll go over the prominent resources I've created and used through out the project and where I've used them to get a better picture of how each part plays into the larger project. 

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
* **Type**: What type of object has these stats, a player/enemy or chest/rock?
* **Max_health**: Maximum amount of health
* **Art**: Sprite2D texture
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

## Signals

## Maze generation


## Position Generation

## Inventory

## State Machines


