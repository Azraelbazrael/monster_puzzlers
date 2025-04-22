extends Node
class_name level_manager
@export var current_map: map_resource

func set_current_map(value: map_resource):
	pass
	
## have a function that calls from main that checks which map resource to load
## have functions that instantiate the enemies and items to the scene.. rolling between max and min in orfer to have a random spawn of enemies
