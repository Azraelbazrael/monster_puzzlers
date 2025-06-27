extends Node
class_name level_manager

@export var map_list: Array[map_resource]

@export var current_map: map_resource: set = set_map

			
#@export var boss_map: map_resource

@onready var tilemap = $"../TileMap"


const m_item = preload("res://item_test_scenes/interactable_items/PickableItem.tscn")
const m_enemy = preload("res://enemy_characters/Enemy_Character.tscn")
const m_rock = preload("res://dungeon_generator/rock.tscn")
const m_boss = preload("res://enemy_characters/Boss_Character.tscn")





func _ready() -> void:
	change_map()
	update_map()
	
	#Global.map_name = current_map.name
	#tilemap.map = current_map
	Global.connect("game_start", add_map_obj)
	Global.connect("game_over", clear_arrays)



func set_map(Map: map_resource):
	current_map = Map
	Global.map_name = current_map.name
	update_map()


	
	
func update_map():
	if current_map is not map_resource:
		return
	if not is_inside_tree():
		await ready	


		
func add_map_obj():
	print(current_map.name)
	if is_inside_tree():
		add_map_items()
		add_map_enemies()
		add_map_rocks()
		add_map_bosses()

func add_map_bosses():
	
	if current_map.map_bosses.size() == 0:
		return
	for i in current_map.map_bosses.size():
		if current_map.map_bosses[ i ] == null or current_map.map_bosses[ i ].enemy == null:
			continue
		var boss_count : int = current_map.map_bosses[ i ].get_drop_count()
		for j in boss_count:
			var boss : BossEnemy = m_boss.instantiate() as BossEnemy
			boss.stats = current_map.map_bosses[ i ].enemy
			get_tree().root.call_deferred("add_child", boss)
			
			boss.global_position = get_parent().end_room.position
			#print(boss.global_position)

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
			get_tree().root.call_deferred("add_child", item)
			
			Global.emit_signal("obj_placed")
			item.global_position = tilemap.rand_point * tilemap.TILESIZE


func add_map_rocks():
	if current_map.map_rocks.size() == 0:
		return
	for i in current_map.map_rocks.size():
		if current_map.map_rocks[ i ] == null or current_map.map_rocks[ i ].rock == null:
			continue
		var item_count : int = current_map.map_rocks[ i ].get_drop_count()
		for j in item_count:
			var rock : Rock = m_rock.instantiate() as Rock
			rock.stats = current_map.map_rocks[ i ].rock
			get_tree().root.call_deferred("add_child", rock)
			
			Global.emit_signal("obj_placed")
			rock.global_position = tilemap.rand_point * tilemap.TILESIZE			

func add_map_enemies():
	if current_map.map_enemies.size() == 0:
		return
	for i in current_map.map_enemies.size():
		if get_tree().root:
			if current_map.map_enemies[ i ] == null or current_map.map_enemies[ i ].enemy == null:
				continue
			var enemy_count : int = current_map.map_enemies[ i ].get_drop_count()
			for j in enemy_count:
				var enemy : EnemyCharacter = m_enemy.instantiate() as EnemyCharacter
				enemy.stats = current_map.map_enemies[ i ].enemy
				enemy.tilemap = tilemap
				get_tree().root.call_deferred("add_child", enemy)
				Global.emit_signal("obj_placed")
				enemy.global_position = tilemap.rand_point * tilemap.TILESIZE
		else:
			pass
			
			
func clear_arrays():
	var items = get_tree().get_nodes_in_group("PickableItems")
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var rocks = get_tree().get_nodes_in_group("Rock")
	

	
	for i in items:
		i.queue_free()
		
	for e in enemies:
		e.queue_free()
		
	for r in rocks:
		r.queue_free()
		
	change_map()	
	
func change_map():
	var new_map = map_list.pick_random()
	set_map(new_map)
	tilemap.set_map(new_map)
