extends State
class_name EnemyIdle

var move_direction: Vector2
var wander_time: float
var move_speed := 4


func _randomize_wander():
	pass
	#move_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	#wander_time = randf_range(1,3)

func _enter_state(_previous_state : State):
	pass
	#_randomize_wander()
	
func physics_update(_delta : float):
	
	if actor:
		
		if actor.current_path.size() > 1:
			actor.current_path.remove_at(0)

		var go_to_pos: Vector2 = actor.current_path[0] + Vector2(actor.tilemap.TILESIZE/2,actor.tilemap.TILESIZE/2)
		actor.global_position = go_to_pos
		
		#actor.global_position = actor.global_position.move_toward(actor.targ_pos.global_position / actor.tilemap.TILESIZE , 5)
		#actor.get_point_path()
		#actor.velocity = move_direction * move_speed	

	
func frame_update(_delta : float):
	pass
	#if wander_time > 0:
	#	wander_time -= _delta
	#else:
		#_randomize_wander()
