extends State
class_name RockIdle


func _enter_state(_previous_state : State):
	pass
	#if actor:
		
func frame_update(_delta : float):
	if actor.stats.health == 0:
		_destroyed()
	

func _destroyed():
	transition.emit("RockDestroy")
	
