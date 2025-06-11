extends State
class_name EnemyAttack
var dmg_time: float = 3


func _enter_state(_previous_state : State):
	if actor.target:
		print("Current State: Attack")
		_damage_target()
		if actor.target == null:
			actor.connect("no_dmg", _unhurt_target)
		
func _damage_target():
	if actor.target:
		dmg_time = 3
		actor.target.emit_signal("player_hurt")
		

func frame_update(_delta : float):
	if dmg_time > 0:
		dmg_time -= _delta
	else:
		_damage_target()
	
func _unhurt_target():
	transition.emit("EnemyIdle")
