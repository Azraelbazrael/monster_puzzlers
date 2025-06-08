extends Area2D
@export var damage: float = 1
@export var rock_damage: float = 1

#func _process(delta: float) -> void:
	#if get_parent().weapon:
	#	damage = get_parent().weapon.damage
		#rock_damage = get_parent().weapon.rock_damage
		
#func _on_body_entered(body):
	#if body.has_method("take_damage"):
	#		body.take_damage(damage)
	#elif body.has_method("break_rock"):
	#	body.break_rock(rock_damage)
