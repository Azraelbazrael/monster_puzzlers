extends State
class_name EnemyChase

var move_speed := 40.0
var recalc_time := 3.0



func _enter_state(_previous_state : State):
	print("current state: Chasing")
	


func physics_update(_delta : float):

		
	if actor:
		##DO ENEMY PATHFINDING LATER
		if actor.target:
			target= actor.target
			var direction = target.global_position - actor.global_position
			if direction.length() > 25:
				actor.velocity = direction.normalized() * move_speed
			else:
				actor.velocity = Vector2()
			
		else:
			transition.emit("EnemyIdle")
			
		
		
		actor.move_and_collide(actor.velocity * _delta)
				
