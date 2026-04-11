class_name StateMachine
extends Node

var _current_state: State

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

func transition_to(state_name: String) -> void:
	var new_state := find_child(state_name) as State
	if not new_state:
		push_error("StateMachine: state not found — " + state_name)
		return
	
	_current_state.exit()
	_current_state = new_state
	_current_state.enter()
