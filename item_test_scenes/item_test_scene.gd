extends Node2D
##make a set space, have items on the bottom collision layer generate randomly from that space

signal restart

signal placed(object)

var pickaxe = preload("res://item_test_scenes/pickaxe.tscn")
var short_sword = preload("res://item_test_scenes/short_sword.tscn")
var evil_rock = preload("res://item_test_scenes/evil_rock.tscn")
var player = preload("res://Playable_character/character.tscn")
var enemy = preload("res://enemy_characters/Dummy.tscn")
var chaser = preload("res://enemy_characters/Chaser.tscn")

var player_c
var rock
var sword 
var enemy_c 
var chaser_c
var pick
#var total_objects = []

@onready var map = $Test_room



func _input(event):
	
	if event.is_action_pressed('ui_select'): ## space_bar
		
		gen_items()
	
	#if event.is_action_pressed('ui_cancel'):
		#player_c.damage_test()
	
	
	
	
	
func gen_items():
	player_c = player.instantiate()
	rock = evil_rock.instantiate()	
	sword = short_sword.instantiate()	
	enemy_c = enemy.instantiate()
	chaser_c = chaser.instantiate()
	pick = pickaxe.instantiate()
	
	add_child(player_c)	
	emit_signal("placed", self)
	player_c.position = map.rand_point * 32
	
	add_child(rock)
	emit_signal("placed", self)
	rock.position = map.rand_point * 32
	
	add_child(sword)	
	emit_signal("placed", self)
	sword.position = map.rand_point * 32
	
	add_child(pick)
	emit_signal("placed", self)
	pick.position = map.rand_point * 32
	
	#add_child(pick)
	#add_child(enemy_c)
	#emit_signal("placed", self)
	#enemy_c.position = map.rand_point * 32
	
	#add_child(chaser_c)
	#emit_signal("placed", self)
	#chaser_c.position = map.rand_point * 32
	
func hide_screenlayer():
	$ScreenLayers.hide()

func _on_screen_layers_on_show() -> void:
	player_c.queue_free()
	rock.queue_free()
	if chaser_c:
		chaser_c.queue_free()
	if pick:
		pick.queue_free()
	if sword:
		sword.queue_free()
		
	$ScreenLayers/textbox.end_button.disabled = false
	
