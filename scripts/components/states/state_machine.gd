class_name StateMachine
extends Node

var _current_state: State

var _dynamic_states: Array[Node] = []

func _ready() -> void:
	var owner_actor := get_parent()
	
	for child in get_children():
		var state := child as State
		
		if state:
			state.actor = owner_actor
	
	_current_state = get_child(0) as State
	call_deferred("_enter_initial_state")

func _enter_initial_state() -> void:
	_current_state.enter()

func _physics_process(delta : float) -> void:
	if not _current_state:
		return
	
	_current_state.process_physics(delta)
	
	var body := get_parent() as CharacterBody2D
	if body:
		body.move_and_slide()

# handles existing states
func transition_to(state_name: String) -> void:
	var new_state := find_child(state_name) as State
	if not new_state:
		push_error("StateMachine: state not found — " + state_name)
		return
	
	_current_state.exit()
	
	_free_if_dynamic(_current_state)
	
	_current_state = new_state
	_current_state.enter()

# handles dynamic states
func transition_to_scene(state_scene: PackedScene) -> void:
	if not state_scene:
		push_error("StateMachine: dynamic state not found")
		return
	
	var new_state = state_scene.instantiate() as State
	
	if not new_state:
		push_error("StateMachine: dynamic state doesn't extend State")
		return
	
	new_state.actor = get_parent()
	add_child(new_state)
	
	_dynamic_states.append(new_state)
	
	_current_state.exit()
	
	_free_if_dynamic(_current_state)
	
	_current_state = new_state
	_current_state.enter()

func _free_if_dynamic(state: State) -> void:
	if state in _dynamic_states:
		_dynamic_states.erase(state)
		state.queue_free()
