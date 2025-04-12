extends Node2D
##make a set space, have items on the bottom collision layer generate randomly from that space

#signal restart

#signal placed(object)

var pickaxe = preload("res://item_test_scenes/interactable_items/pickaxe.tscn")
var short_sword = preload("res://item_test_scenes/interactable_items/short_sword.tscn")
var evil_rock = preload("res://item_test_scenes/evil_rock.tscn")
var player = preload("res://Playable_character/character.tscn")
var enemy = preload("res://enemy_characters/Dummy.tscn")
var chaser = preload("res://enemy_characters/Chaser.tscn")
var iron_rock = preload("res://item_test_scenes/iron_rock.tscn")

var player_c
var rock
var sword 
var enemy_c 
var chaser_c
var pick
var i_rock


@onready var map = $Test_room

func _ready() -> void:
	Global.connect("game_over", show_screenlayer)
	Global.connect("generate_dungeon", hide_screenlayer)
	
func _input(event):
	
	if event.is_action_pressed('ui_select'): ## space_bar
		
		gen_items()
	
	
	
	
	
func gen_items():
	player_c = player.instantiate()
	rock = evil_rock.instantiate()	
	sword = short_sword.instantiate()	
	enemy_c = enemy.instantiate()
	chaser_c = chaser.instantiate()
	pick = pickaxe.instantiate()
	i_rock = iron_rock.instantiate()
	
	add_child(player_c)	
	Global.emit_signal("obj_placed")
	player_c.position = map.rand_point * 32
	
	add_child(rock)
	Global.emit_signal("obj_placed")
	rock.position = map.rand_point * 32
	
	add_child(sword)	
	Global.emit_signal("obj_placed")
	sword.position = map.rand_point * 32
	
	add_child(pick)
	Global.emit_signal("obj_placed")
	pick.position = map.rand_point * 32
	
	add_child(i_rock)
	Global.emit_signal("obj_placed")
	i_rock.position = map.rand_point * 32

func show_screenlayer():
	$ScreenLayers.show()
	
func hide_screenlayer():
	$ScreenLayers.hide()
	

	
