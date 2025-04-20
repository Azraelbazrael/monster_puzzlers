extends rock
class_name iron_rock

func broken_rock():
	visible = false
	emit_signal("item_drop")
	drop_items()
	queue_free()
	
