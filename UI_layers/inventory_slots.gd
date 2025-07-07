extends GridContainer
@onready var slots = get_children()

signal item_changed
@export var ITEM: Item_resource

func _ready() -> void:
	add_item(ITEM)


func equip(item: Item_resource):
	var character_child = get_tree().root.get_node("Character")
	var char_child = get_tree().current_scene.get_node("Character")
	
	if	item != null:
		add_item(item)
		if character_child:
			character_child.current_item = item
		elif char_child:
			char_child.current_item = item
		
		
	else:
		return
		
		
func add_item(item : Item_resource):
	for slot in slots:
		if slot.item == null:
			slot.item = item
			item_changed.emit()
			return
	print("Can't add any more item...")

func remove_item(item : Item_resource):
	for slot in slots:
		if slot.item == item:
			slot.item = null
			item_changed.emit()
			return
	print("Item not found...")

func is_available(item):
	for i in get_children():
		if i.item == item:
			return true
	return false

func test():
	print("test")
