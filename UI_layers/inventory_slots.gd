extends GridContainer
@onready var slots = get_children()

signal item_changed
#var item_count = []	

		
func add_item(item : Item_resource):
	for slot in slots:
		if slot.item == null:
			slot.item = item
			#item_count.append(item)
			item_changed.emit()
			#print(item.name)
			return
	print("Can't add any more item...")

func remove_item(item : Item_resource):
	for slot in slots:
		if slot.item == item:
			slot.item = null
			item_changed.emit()
			#print(item.name)
			return
	print("Item not found...")

func is_available(item):
	for i in get_children():
		if i.item == item:
			return true
	return false

func test():
	print("test")
