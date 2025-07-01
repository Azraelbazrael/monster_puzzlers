extends CharacterBody2D
class_name EnemyCharacter

signal dead_enemy
signal befriended
signal attack_target


var damaged: bool
@onready var playerCollision: RayCast2D = $PlayerCollision

@export var speed: int =  30
@export var radius_limit: int =  80

@export var stats: Stats: set = set_stats
@export var damage_label: PackedScene
@export var befriend: PackedScene
@export var hurtbox: Area2D
@export var knockback_mod: float = 0.1
@export var stateMachine: Node
@export var player_detect: Area2D

var radius_squared = radius_limit**2
var mov_direction = Vector2()
var knockback_dir = Vector2.ZERO
var knockback = Vector2.ZERO


var target
var weapon
var is_damaged: bool = false
var tilemap: TileMap
var current_path: Array[Vector2i]

signal player_found

func _ready():
	$Sprite2D.texture = stats.art
	

func set_stats(value: Stats) -> void:
	stats = value.create_instance()
	stateMachine.actor = self
	stateMachine.states = stats.states
	update_monster()



func update_monster() -> void:
	if stats is not Stats:
		return
	if not is_inside_tree():
		await ready	


func _add_dmg_label(amount: int):
	var damage = damage_label.instantiate()
	damage.find_child("Label").text = str(amount)
	damage.position = $text_pos.position
	add_child(damage)


func _process(_delta):
	
	if stats.health == 0:
		emit_signal("dead_enemy")
		
	if velocity.x < 0: ## flips sprite based on direction
			$Sprite2D.flip_h = true

	elif velocity.x > 0:
			$Sprite2D.flip_h = false

func _physics_process(delta: float) -> void:

	move_and_collide(velocity * delta)

func _on_dead_enemy() -> void:
	visible = false
	queue_free()


func _on_player_detection_area_entered(targ_d: Area2D) -> void:
	if targ_d.get_parent().is_in_group("Player"):
		target = targ_d.get_parent()
		player_found.emit()
		

func _on_player_detection_area_exited(targ_d: Area2D) -> void:
	if targ_d.get_parent().is_in_group("Player"):
		target = null

func _on_hurtbox_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Weapon"):
		weapon = area.get_parent()
		if weapon.weapon.is_weapon:
				weapon.weapon.use_cost(weapon.get_parent().get_parent().character_stats)
				_add_dmg_label(weapon.weapon.damage)
				stats.take_damage(weapon.weapon.damage)
		else:
			_befriend_check()
func _on_hurtbox_exited(weapon: Area2D) -> void:
	if weapon.get_parent().is_in_group("Weapon"):
		weapon = null

func _befriend_check():
	var flag = []
 	
	if stats.Triggers:
		for i in range(stats.Triggers.size()):
			if stats.Triggers[i] == null:
				continue
			flag.append(stats.Triggers[i])
		for f in flag.size():
			if flag[f].item == weapon.weapon:
				emit_signal("befriended")


func _on_befriended() -> void:
	visible = false
	var friend = befriend.instantiate()
	friend.stats = stats
	friend.position = global_position
	get_tree().root.call_deferred("add_child", friend)
	queue_free()

func accelerate_towards_point(point, delta):
	var movement = mov_direction * speed
	mov_direction = (point.position - position).normalized()
	velocity = movement + (knockback * 2)
	velocity = velocity.move_toward(mov_direction * speed, 200 * delta)
	move_and_slide()

func checkplayerdistance(target):
	var distance_squared = (target.position.x - global_position.x)**2 + (target.position.y - global_position.y)**2
	if distance_squared <= radius_squared:
		playerCollision.target_position = target.position - global_position
		if playerCollision.is_colliding():
			return true
		else:
			return false
