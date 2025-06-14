class_name Weapon_resource
extends Item_resource

enum Weapon_type{MELEE, RANGED}

@export var cost: int
@export var damage: float
@export var weapon_type: Weapon_type
@export var recipe: Array[Item_resource]
@export var rock_damage: float

func use_cost(char_stats: Character_stats) -> void:
	if cost:
		char_stats.stamina -= cost

func create_instance() -> Resource:
	var instance: Item_resource = self.duplicate()
	return instance
