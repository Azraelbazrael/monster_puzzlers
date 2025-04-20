extends Node2D
##make a set space, have items on the bottom collision layer generate randomly from that space


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
	
	add_child(player_c)	
	Global.emit_signal("obj_placed")
	player_c.position = map.rand_point * 32
	
func show_screenlayer():
	$ScreenLayers.show()
	
func hide_screenlayer():
	$ScreenLayers.hide()
	

	
