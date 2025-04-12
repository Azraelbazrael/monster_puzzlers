extends Sprite2D
class_name PickableItem

@export var item: Item_resource

func _ready():
	texture = item.art
	
func _on_player_entered(body):
	if body.has_method("add_item"):
		body.add_item(item)
		queue_free()
