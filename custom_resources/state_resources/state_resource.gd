extends Resource
class_name State

var previous_state : State
var actor: EnemyCharacter
var target: PlayerCharacter

var state_name: StringName
 
var is_current: bool = false
 
var transition_done : bool = false :
	set(value):
		transition_done = value
 
signal transition(next_state : StringName)
 
func create_instance() -> Resource:
	var instance: State = self.duplicate()	
	return instance	
	
func _enter_state(_previous_state : State):
	pass
 
func _exit_state():
	transition_done = false
	is_current = false
 
func frame_update(_delta : float):
	pass
 
func physics_update(_delta : float):
	pass
 
#func animation_finished(_anim_name: StringName):
#	pass
