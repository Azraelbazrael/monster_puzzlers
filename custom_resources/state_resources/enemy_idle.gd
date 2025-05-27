extends State
class_name EnemyIdle

var move_direction: Vector2
var wander_time: float
var move_speed := 50


func _randomize_wander():
	move_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	wander_time = randf_range(2,5)

func _enter_state(_previous_state : State):
	print("current state: Idle")
	if actor:
		actor.connect("player_found", _found_player)
		
	_randomize_wander()
	
func physics_update(_delta : float):
	if actor:
		actor.velocity = Vector2(move_direction) * move_speed
		var collision = actor.move_and_collide(actor.velocity * _delta)
		if collision:
			wander_time = 0
			actor.velocity = actor.velocity.bounce(collision.get_normal())

func _found_player():
	transition.emit("EnemyChase")
	


func frame_update(_delta : float):
	if wander_time > 0:
		wander_time -= _delta
	else:
		_randomize_wander()
