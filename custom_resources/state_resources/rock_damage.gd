extends State
class_name RockDamage
var dmg_time: float = 1.5

func _enter_state(_previous_state : State):
	if actor:
		print("current state: Rock Damage")
		_damage_rock()
		actor.connect("un_dmg", _undamage_rock)
		


func _damage_rock():
	if actor.hurt_by:
		dmg_time = 1.5
		actor.add_dmg_label(actor.hurt_by.current_item.rock_damage)
		actor.stats.take_damage(actor.hurt_by.current_item.rock_damage)
	
	if actor.stats.health == 0:
		_destroy_rock()	
	

func frame_update(_delta : float):
	if dmg_time > 0:
		dmg_time -= _delta
	else:
		_damage_rock()	
		
		
func _undamage_rock():
	transition.emit("RockIdle")

func _destroy_rock():
	transition.emit("RockDestroy")
