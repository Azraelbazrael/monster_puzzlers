extends State
class_name EnemyDamage

var dmg_time: float = 1.5

func _enter_state(_previous_state : State):
	#print("current state: Damaged")
	if actor:
		_damage_enemy()
		actor.connect("no_dmg", _undamage)
		
	#_randomize_wander()
func _damage_enemy():
	dmg_time = 1.5
	if actor.weapon:
		actor._add_dmg_label(actor.weapon.current_item.damage)
		actor.stats.take_damage(actor.weapon.current_item.damage)
	
func frame_update(_delta : float):
	if dmg_time > 0:
		dmg_time -= _delta
	else:
		_damage_enemy()	
		

func _undamage():
	transition.emit("EnemyIdle")
