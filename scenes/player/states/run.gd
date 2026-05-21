class_name RunState
extends PlayerState

func enter() -> void:
	super()
	player.anim_player.play("run")
	
	AudioManager.play_sfx_looped("footstep_grass", -15.0)

func process_physics(delta: float) -> void:
	if not player: return
	
	
	
	# -------------STATE LOGIC-------------

	apply_horizontal_movement(delta)
	apply_gravity(delta)
	
	# -------------TRANSITION LOGIC-------------
	
	var on_floor : bool = player.is_on_floor()
	
	if Input.is_action_just_pressed("jump") and on_floor:
		_state_machine.transition_to("Jump")
		return
	
	# no velocity check needed, can only go down from running
	if not on_floor:
		# before transitioning to fall, start the coyote timer
		player.coyote_timer = player.coyote_time
		_state_machine.transition_to("Fall")
		return
	
	if player.direction == 0 and absf(player.velocity.x) < 0.1:
		_state_machine.transition_to("Idle")
		return

func exit() -> void:
	AudioManager.stop_sfx_looped("footstep_grass")
