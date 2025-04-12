extends Sprite2D
class_name HeldWeapon
@export var weapon: Weapon_resource

@onready var weaponfx = $WeaponFX
@onready var hitbox = $Hitbox

func use_weapon():
	if weapon != null:
			get_node("WeaponFX").play(weapon.animation)
	else:	
		pass
