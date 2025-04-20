extends CharacterBody2D
class_name rock

signal item_drop
const PICKUP = preload("res://item_test_scenes/interactable_items/PickableItem.tscn")
##add drop data here later...

@export var stats: Stats: set = set_stats
@export var damage_label: PackedScene
var can_be_damaged: bool


func _ready() -> void:
	$Sprite2D.texture = (stats.art)
	connect("item_drop", drop_items)
	
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
	if stats.drops.size() == 0:
		return
	
	for i in stats.drops.size():
		if stats.drops[ i ] == null or stats.drops[ i ].item == null:
			continue
		var drop_count : int = stats.drops[ i ].get_drop_count()
		for j in drop_count:
			var drop : PickableItem = PICKUP.instantiate() as PickableItem
			drop.item_data = stats.drops[ i ].item
			get_tree().root.call_deferred( "add_child", drop )
			drop.global_position = global_position
			drop.velocity = velocity.rotated( randf_range( -1.5, 1.5 ) ) * randf_range( 0.9 , 1.5 )
			
	pass
	
