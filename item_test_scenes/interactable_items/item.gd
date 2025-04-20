@tool 

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

#func _ready():
	#texture = item.art
func _on_body_entered( b ) -> void:
	if b is PlayerCharacter:
		if item_data:
			emit_signal("picked_up")
			visible = false
			b.add_item(item_data)
			queue_free()
	pass	

func _physics_process(delta):
	var collision_info = move_and_collide( velocity * delta )
	if collision_info:
		velocity = velocity.bounce( collision_info.get_normal() )
	velocity -= velocity * delta * 4 
	
	
func _update_texture() -> void:
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.art
	pass
