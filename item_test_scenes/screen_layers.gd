extends CanvasLayer
signal on_show
signal on_hide

func _on_visibility_changed() -> void:
	if visible == true:
		emit_signal("on_show")
	if visible == false:
		emit_signal("on_hide")
