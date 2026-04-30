class_name FallState
extends PlayerState

func enter() -> void:
	super()
	
	player.anim_player.play("air")

func process_physics(delta: float) -> void:
	if not player: return
	
	# -------------STATE LOGIC-------------
	
	apply_horizontal_movement(delta)
	apply_gravity(delta)
	
	# -------------TRANSITION LOGIC-------------
	
	var on_floor : bool = player.is_on_floor()
	
	if on_floor:
		if player.jump_buffer_timer > 0.0:
			player.jump_buffer_timer = 0.0
			_state_machine.transition_to("Jump")
			return
		if absf(player.velocity.x) < 0.1:
			_state_machine.transition_to("Idle")
			return
		else:
			_state_machine.transition_to("Run")
			return
	
	if Input.is_action_just_pressed("jump") and player.coyote_timer > 0.0:
		player.coyote_timer = 0.0
		_state_machine.transition_to("Jump")
		return
