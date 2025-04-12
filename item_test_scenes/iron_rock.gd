extends rock


func broken_rock():
	Global.emit_signal("item_drop")
