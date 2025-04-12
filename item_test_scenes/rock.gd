extends RigidBody2D
class_name rock

#signal rock_broken
@export var stats: Stats: set = set_stats
@export var damage_label: PackedScene
var can_be_damaged: bool


func _ready() -> void:
	$Sprite2D.texture = (stats.art)
	Global.connect("item_drop", drop_items)
	
func set_stats(value: Stats) -> void:
	stats = value.create_instance()
	


func break_rock(amount: float):
	stats.take_damage(amount)
	var damage = damage_label.instantiate()
	damage.position = position
	damage.find_child("Label").text = str(amount)
	get_tree().current_scene.add_child(damage)	
	take_damage_cooldown(0.5)
			
	if stats.health == 0:
		broken_rock()

func take_damage_cooldown(wait_time):
	can_be_damaged = false
	await get_tree().create_timer(wait_time).timeout
	can_be_damaged = true

func broken_rock():
	pass
	
func drop_items():
	pass
