class_name DoubleJumpState
extends PlayerState

func enter() -> void:
	super()
	player.velocity.y = -1 * player.jump_force
	player.anim_player.play("air")

func process_physics(delta: float) -> void:
	if not player: return
	
	# -------------STATE LOGIC-------------
	
	apply_horizontal_movement(delta)
	apply_gravity(delta)
	
	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y *= player.jump_cut_multiplier
	
	# -------------TRANSITION LOGIC-------------
	
	var on_floor := player.is_on_floor()
	
	if player.velocity.y >= 0:
		_state_machine.transition_to("Fall")
		return
	
	if on_floor:
		if absf(player.velocity.x) > 0.1:
			_state_machine.transition_to("Run")
		else:
			_state_machine.transition_to("Idle")
