extends Sprite2D
#signal weapon_changed
@export var weapon: Weapon_resource

@onready var weaponfx = $WeaponFX
@onready var hitbox = $Hitbox
