extends rock
class_name iron_rock

func broken_rock():
	Global.emit_signal("item_drop")

func drop_items():
	print("hello")
