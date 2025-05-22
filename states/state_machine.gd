extends Node
class_name FiniteStateMachine

@export var default_state: State
@export var actor = Stats


var current_state : State
var previous_state: State
@export var states : Dictionary[StringName, State] = {}

func _ready() -> void:
	if states.size() > 0:
		for state : StringName in states.keys():
			states[state].transition.connect(_on_state_transition)
			states[state].actor = actor
			states[state].state_name = state
 
	default_state.actor = actor
	default_state.transition.connect(_on_state_transition)
	change_state(default_state)
 
func change_state(new_state : State):
	if current_state:
		current_state._exit_state()
	current_state = new_state
	current_state.is_current = true
	new_state._enter_state(previous_state)
 
 
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
		
