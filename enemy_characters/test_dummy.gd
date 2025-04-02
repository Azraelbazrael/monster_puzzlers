extends EnemyCharacter

func _on_dead_enemy() -> void:
	self.queue_free()
