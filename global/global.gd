extends Node

signal weapon_changed
signal player_died
signal rock_broken
signal generate_dungeon
signal obj_placed
signal game_start
signal game_over
signal level_passed

signal boss_time
var boss_level: bool = false

#signal map_astar_grid(AStarGrid2D)

#signal enemy_dead(object) ## currently unused

var current_level = 0
