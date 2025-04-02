extends CharacterBody2D
class_name EnemyCharacter

signal dead_enemy
signal taking_dmg
var damaged: bool

@export var stats: Stats: set = set_stats
@export var damage_label: PackedScene
@export var hitbox: Area2D
@export var knockback_mod: float = 0.1
#var knockback_modifier

func _ready():
	$Sprite2D.texture = stats.art

func set_stats(value: Stats) -> void:
	stats = value.create_instance()
	update_monster()

func update_monster() -> void:
	if stats is not Stats:
		return
	if not is_inside_tree():
		await ready	


func take_damage(amount):
	emit_signal("taking_dmg")
	stats.take_damage(amount)
	damaged = true
	var damage = damage_label.instantiate()
	
	damage.find_child("Label").text = str(amount)
	damage.position = position
	get_tree().current_scene.add_child(damage)
	damaged = false


func _process(_delta):
	if stats.health == 0:
		emit_signal("dead_enemy")
		
	if velocity.x < 0:
			$Sprite2D.flip_h = true

	elif velocity.x > 0:
			$Sprite2D.flip_h = false



func _on_dead_enemy() -> void:
	pass


func knockback(dmg_source_pos: Vector2, received_dmg: float):
	var knockback_dir = dmg_source_pos.direction_to(self.global_position)
	var knockback_strng = received_dmg * knockback_mod
	var knckback = knockback_dir * knockback_strng
	
	self.global_position += knckback

	
func _on_hurtbox_area_entered(hitbox: Area2D) -> void:
	pass
