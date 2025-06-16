extends State
class_name EnemyShoot

var move_direction: Vector2
var cooldown_time: float

func _shoot():
	if actor:
		cooldown_time = 0.3
		for b in actor.stats.bullets.size():
			var bullet: Projectile = actor.projectiles.instantiate() as Projectile
			bullet.stats = actor.stats.bullets[b]
			bullet.dir = actor.rotation
			bullet.spawn_pos = actor.global_position
			bullet.spawn_rot = actor.rotation
			bullet.zdex = actor.z_index - 1
			actor.get_tree().root.call_deferred("add_child", bullet)

func _enter_state(_previous_state : State):
	print("current state: Shooting")
	cooldown_time = 0.3
	if actor:
		_shoot()
			


func frame_update(_delta : float):
	if cooldown_time > 0:
		cooldown_time -= _delta
	else:
		_shoot()
		
		
