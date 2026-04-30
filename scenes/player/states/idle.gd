class_name IdleState
extends PlayerState

func enter() -> void:
	super()
	player.anim_player.play("idle")

func process_physics(delta: float) -> void:
	if not player: return
	
	# -------------STATE LOGIC-------------
	
	apply_gravity(delta)
	
	# -------------TRANSITION LOGIC-------------
	
	var on_floor : bool = player.is_on_floor()
	
	if Input.is_action_just_pressed("jump") and on_floor:
		_state_machine.transition_to("Jump")
		return
	
	if not on_floor and player.velocity.y > 0:
		# before transitioning to fall, start the coyote timer
		player.coyote_timer = player.coyote_time
		_state_machine.transition_to("Fall")
		return
	
	if(player.direction != 0):
		_state_machine.transition_to("Run")
		return
