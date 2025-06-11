class_name Stats
extends Resource

enum Type{PLAYER,MONSTER,INTERACTABLE}

@export var type: Type
@export var max_health := 1
@export var art: Texture
@export var damage: float
@export var knockbak_mod: float
@export var is_special_rock: bool = false

@export_group("Item drops")
@export var drops: Array[DropData]

@export_group("States")

@export var states: Dictionary[StringName, State] = {}



var health: int : set = set_health ## CURRENT health, different from total health

 
func set_health(value : int) -> void:
	health = clampi(value, 0, max_health)
	
func take_damage(damage : int) -> void:
	if damage <= 0:
		return
	self.health -= damage
	
func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	return instance

#func create_states() -> Resource:
	#var new_states: State = states.duplicate()
	#return new_states
	
