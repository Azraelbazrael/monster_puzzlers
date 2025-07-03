extends Node

signal weapon_changed
signal player_died
signal rock_broken
signal generate_dungeon
signal obj_placed
signal game_start
signal game_over
signal level_passed
signal game_complete

signal boss_time

var map_name: StringName
var boss_level: bool = false
var player_party: Array[Node2D] ##untested party system for monster recruits


var current_level = 0
