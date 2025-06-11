extends State
class_name PlayerDamage

var dmg_time: float = 3

func _enter_state(_previous_state : State):
	if actor.hurt_by:
		_damage_player()
		if actor.hurt_by == null:
			actor.connect("player_unhurt", _unhurt_player)

		
func _damage_player():
	if actor.hurt_by:
		dmg_time = 3
		actor._add_dmg_label()
		actor.character_stats.take_damage(actor.hurt_by.stats.damage)
		

func frame_update(_delta : float):
	if dmg_time > 0:
		dmg_time -= _delta
	else:
		_damage_player()
	

func _unhurt_player():
	transition.emit("PlayerIdle")
