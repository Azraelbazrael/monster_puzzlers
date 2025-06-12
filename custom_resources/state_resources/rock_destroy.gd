extends State
class_name RockDestroy


func _enter_state(_previous_state : State):
	if actor:
		if actor.stats.is_special_rock == true:
			Global.emit_signal("game_over")
		else:
			actor.visible = false
			actor.emit_signal("item_drop")
			actor.queue_free()
