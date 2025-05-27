extends State
class_name EnemyChase

var move_speed := 100.0
var recalc_time := 3.0
func _enter_state(_previous_state : State):
	print("current state: Chasing")
	


func physics_update(_delta : float):
	if actor.current_path:
		var target_pos = actor.tilemap.map_to_local(actor.current_path.front())
		
		actor.global_position = actor.global_position.move_toward(target_pos,5)
		if actor.global_position == target_pos:
			actor.current_path.pop_front()
	else:
		transition.emit("EnemyIdle")
		
