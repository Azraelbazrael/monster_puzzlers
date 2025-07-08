extends Node
class_name FiniteStateMachine

@export var default_state: State
@export var actor: CharacterBody2D


var current_state : State
var previous_state: State
@export var states : Dictionary[StringName, State] = {}


	
		
func _ready() -> void:
	if states.size() > 0:
		for state: StringName in states.keys():
			states[state].transition.connect(_on_state_transition)
			states[state].state_name = state
			#if actor.is_in_group("Enemy"):
			#	default_state = states["EnemyIdle"]	
			#elif actor.is_in_group("Party"):
				#default_state = states["FriendIdle"]	
	if actor.is_in_group("Player"):
		default_state = actor.character_stats.default_state
	elif actor.is_in_group("Party"):
		default_state = actor.stats.default_fstate
	else:
		default_state = actor.stats.default_state	
	#print(actor, default_state)
	change_state(default_state)


func change_state(new_state : State):
	var n_state = new_state.create_instance()
	n_state.actor = actor
	n_state.transition.connect(_on_state_transition)
	

	if current_state:
		current_state._exit_state()	
	current_state = n_state
	current_state.is_current = true

	n_state._enter_state(previous_state)
 
 
func _on_state_transition(next_state : StringName):
	if current_state:
		previous_state = current_state
	change_state(states[next_state])
	
 
 
func _process(delta):
	if current_state:
		current_state.frame_update(delta)
 
func _physics_process(delta) -> void:
	if current_state:
		current_state.physics_update(delta)
