extends CharacterBody2D
class_name EnemyCharacter

signal dead_enemy
signal attack_target
signal taking_dmg
signal no_dmg

var damaged: bool


@export var stats: Stats: set = set_stats
@export var damage_label: PackedScene
@export var hurtbox: Area2D
@export var knockback_mod: float = 0.1
@export var stateMachine: Node
@export var player_detect: Area2D

var home_pos = Vector2.ZERO

var target
var weapon
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
	if area.get_parent().is_in_group("Player"):
		weapon = area.get_parent()
		#pass
		
func _on_hurtbox_exited(weapon: Area2D) -> void:

	if weapon.get_parent().is_in_group("Player"):
		weapon = null
		no_dmg.emit()
