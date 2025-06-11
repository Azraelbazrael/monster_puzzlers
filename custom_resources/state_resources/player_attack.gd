extends State
class_name PlayerAttack
var dmg_time: float = 1.5

func _enter_state(_previous_state : State):
	if actor.target:
		print("Current State: Player Attack")
		_damage_target()
		if actor.target == null:
			actor.connect("player_hit_stop", _unhurt_target)
	else:
		transition.emit("PlayerIdle")
		
func _damage_target():
	if actor.target:
		dmg_time = 1.5
		actor.target.emit_signal("taking_dmg")
		actor.current_item.use_cost(actor.character_stats)

func frame_update(_delta : float):
	if dmg_time > 0:
		dmg_time -= _delta
	else:
		_damage_target()
	

func _unhurt_target():
	transition.emit("PlayerIdle")
