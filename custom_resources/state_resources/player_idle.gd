extends State
class_name PlayerIdle


func _enter_state(_previous_state : State):
	if actor:
		actor.connect("player_hurt", _damaged)
		actor.connect("player_hit", _attack)
	

func _damaged():
	transition.emit("PlayerDamage")

func _attack():
	transition.emit("PlayerAttack")
