extends Node
class_name level_manager
@export var current_map: map_resource: set = set_map

const m_item = preload("res://item_test_scenes/interactable_items/PickableItem.tscn")
const m_enemy = preload("res://enemy_characters/Enemy_Character.tscn")

var m_items: Array[Node2D]
var m_enemies: Array[Node2D]

func _ready() -> void:
	$"../TileMap".map = current_map
	Global.connect("game_start", add_map_obj)
	Global.connect("game_over", clear_arrays)
	
func set_map(Map: map_resource):
	current_map = Map
	update_map()

func update_map():
	if current_map is not map_resource:
		return
	if not is_inside_tree():
		await ready	
		
		
func add_map_obj():
	add_map_items()
	add_map_enemies()
	print(m_items.size())
	
func add_map_items():
	if current_map.map_items.size() == 0:
		return
	for i in current_map.map_items.size():
		if current_map.map_items[ i ] == null or current_map.map_items[ i ].items == null:
			continue
		var item_count : int = current_map.map_items[ i ].get_drop_count()
		for j in item_count:
			var item : PickableItem = m_item.instantiate() as PickableItem
			item.item_data = current_map.map_items[ i ].items
			m_items.append(item)
			get_tree().root.call_deferred("add_child", item)
			Global.emit_signal("obj_placed")
			item.global_position = $"../TileMap".rand_point * 32
			

func add_map_enemies():
	if current_map.map_enemies.size() == 0:
		return
	for i in current_map.map_enemies.size():
		if current_map.map_enemies[ i ] == null or current_map.map_enemies[ i ].enemy == null:
			continue
		var enemy_count : int = current_map.map_enemies[ i ].get_drop_count()
		for j in enemy_count:
			
			var enemy : EnemyCharacter = m_enemy.instantiate()
			enemy.stats = current_map.map_enemies[ i ].enemy
			m_enemies.append(enemy)
			get_tree().root.call_deferred("add_child", enemy)
			Global.emit_signal("obj_placed")
			enemy.global_position = $"../TileMap".rand_point * 32


func clear_arrays():
	if m_items.size() != 0:
		for i in m_items:
			i.queue_free()
		
	if m_enemies.size() != 0:	
		for e in m_enemies:
			e.queue_free()	
			
##fix this later
