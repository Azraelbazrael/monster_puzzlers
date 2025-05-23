extends State
class_name EnemyChase

var move_speed := 100.0

func _enter_state(_previous_state : State):
	pass


func physics_update(_delta : float):
	if target && actor:
		var direction = target.global_position - actor.global_position 
		if direction.length() > 50:
			actor.velocity = move_speed * direction.normalized()
		else:
			actor.velocity = Vector2()
		if direction.length() > 200:
			transition.emit("res://custom_resources/stats/enemy_resouces/chaser.tres::Resource_bv0bu")
