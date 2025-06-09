#extends EnemyCharacter
#class_name ChaserEnemy


#func _on_dead_enemy() -> void:
#	self.queue_free()

#f#unc _physics_process(delta: float) -> void:
	#move_and_collide(velocity * delta)



#func _on_hurtbox_area_entered(hitbox: Area2D) -> void:
	#if hitbox.get_parent().is_in_group("Weapon"):
		#knockback(hitbox.get_parent().global_position, hitbox.get_parent().hitbox.damage)
