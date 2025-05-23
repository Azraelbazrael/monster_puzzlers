extends Node
class_name FiniteStateMachine

@export var default_state: State
@export var actor: EnemyCharacter


var current_state : State
var previous_state: State
@export var states : Array[State]: set = _set_states


##need to duplicate and establish states before ready is called to make sure that each enemy can move individually
## maybe i shot myself in the foot by making it a dictionary... will change to an array tomorrow

func _set_states(new_states: Array[State]):
	#new_states = states.map( func(x): return x.duplicate() )
	#print(a)
	states = new_states.duplicate()
	
		
func _ready() -> void:
	print(states)
	#states.duplicate(true)
	var player = get_tree().get_first_node_in_group("Player")
	if states.size() > 0:
		for state in states:
#			states[state].create_instance()
			states[state].transition.connect(_on_state_transition)
			states[state].actor = actor
		#	states[state].state_name = state
		#	states[state].target = player
			
			
	default_state.actor = actor
	default_state.target = player
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
	#change_state(states[next_state])
 
 
func _process(delta):
	if current_state:
		
		current_state.frame_update(delta)
 
func _physics_process(delta) -> void:
	if current_state:
		#print(current_state)
		current_state.physics_update(delta)
