#extends State
#class_name EnemyChase

#var player: CharacterBody2D
#@export var enemy : CharacterBody2D
#@export var move_speed := 100.0
#@export var PlayerDetector: Area2D

#func Enter():
	
#	player = get_tree().get_first_node_in_group("Player")
	
#func Physics_Update(delta: float):
	#var direction = player.global_position - enemy.global_position 
	#if direction.length() > 50:
	#	enemy.velocity = move_speed * direction.normalized()
	#else:
		#enemy.velocity = Vector2()
	
	#if direction.length() > 200:
		#Transitioned.emit(self,"idle")
