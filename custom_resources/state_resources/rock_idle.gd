extends State
class_name RockIdle


func _enter_state(_previous_state : State):
	if actor:
		actor.connect("taking_dmg", _damaged)
		if actor.stats.health == 0:
			_destroyed()
		

func _destroyed():
	transition.emit("RockDestroy")
	
func _damaged():
	transition.emit("RockDamage")
