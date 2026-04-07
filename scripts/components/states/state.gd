class_name State
extends Node

var actor : Node

var state_machine : StateMachine

func _ready() -> void:
	state_machine = get_parent() as StateMachine

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_physics(_delta) -> void:
	pass

func process_input(_event) -> void:
	pass
