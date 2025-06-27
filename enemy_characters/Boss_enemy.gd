extends EnemyCharacter
class_name BossEnemy

const projectiles = preload("res://battle/projectile.tscn")


func _ready() -> void:

	$Sprite2D.texture = stats.art
	


func _on_dead_enemy() -> void:
	visible = false
	Global.emit_signal("game_complete")
	queue_free()
