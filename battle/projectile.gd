extends CharacterBody2D
class_name Projectile

var stats: projectile_resource
var SPEED = 300

var dir: float
var spawn_pos: Vector2
var spawn_rot: float
var zdex: int
var life: float

func _ready() -> void:
	life = 3
	$Sprite2D.texture = stats.art
	global_position = spawn_pos
	global_rotation = spawn_rot
	z_index = zdex

func _physics_process(delta: float) -> void:
	velocity = Vector2(0,-SPEED).rotated(dir)
	
	
	move_and_slide()
	
	
	
func _process(delta: float) -> void:
	if life > 0:
		life - 1
	else:
		queue_free()
		
	


	
func _on_hitbox_body_entered(body: Node2D) -> void:
	if "Enemy" in body.name:
		pass
	else:
		queue_free()
