extends Area2D

@export var damage: float = 1

#func _input(event: InputEvent) -> void:
	
func _on_body_entered(body):
	if body.has_method("take_damage"):
			body.take_damage(damage)
			
	#elif body.has_method("level_exit"):
	#	body.level_exit()
