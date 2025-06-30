class_name Item_resource
extends Resource

enum Type{COLLECTABLE, WEAPON}

@export_group("Item Attributes")
@export var type: Type
@export var art: Texture
@export var name: String
@export var stackable: bool
@export var max_stack: int
@export var animation : String


#@export var is_trigger: bool
@export var is_weapon: bool

@export_multiline var item_desc: String
