extends State
class_name EnemyIdle

var move_direction: Vector2
var wander_time: float
var move_speed := 100.0


func _randomize_wander():
	move_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	wander_time = randf_range(1,3)

func _enter_state(_previous_state : State):
	_randomize_wander()
	
func physics_update(_delta : float):
	if actor:
		actor.velocity = move_direction * move_speed	
	if target:
		var direction = target.global_position - actor.global_position 
		if direction.length() < 90:
			transition.emit("res://custom_resources/stats/enemy_resouces/chaser.tres::Resource_2bt41")
	
func frame_update(_delta : float):
	if wander_time > 0:
		wander_time -= _delta
	else:
		_randomize_wander()
