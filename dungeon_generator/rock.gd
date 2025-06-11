extends CharacterBody2D
class_name Rock

signal item_drop
signal taking_dmg
signal un_dmg

const PICKUP = preload("res://item_test_scenes/interactable_items/PickableItem.tscn")
##add drop data here later...

@export var stats: Stats: set = set_stats
@export var damage_label: PackedScene
@onready var state_machine: FiniteStateMachine = $StateMachine
var states : Dictionary[StringName, State] = {}

var hurt_by
var can_be_damaged: bool


func _ready() -> void:
	$Sprite2D.texture = stats.art
	states = stats.states
	state_machine.states = states
	connect("item_drop", drop_items)
	
	
func set_stats(value: Stats) -> void:
	stats = value.create_instance()
	
	update_rock()


func add_dmg_label(amount: int):
	var dmg_label = damage_label.instantiate()
	dmg_label.position = $Marker2D.position 
	dmg_label.find_child("Label").text = str(amount)
	add_child(dmg_label)

func update_rock() -> void:
	if stats is not Stats:
		return
	if not is_inside_tree():
		
		await ready	



func _on_rock_range_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		hurt_by = area.get_parent()



func _on_rock_range_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("Weapon"):
		hurt_by = null
		emit_signal("un_dmg")


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
			drop.velocity = global_position.rotated(randf_range(-1.5, 1.5) * randf_range(0.9, 1.5)) / 2.5
			
	pass
