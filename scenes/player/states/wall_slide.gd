class_name WallSlideState
extends PlayerState

func enter() -> void:
	super()
	player.velocity.x = 0.0
	player.sprite.play("fall")

func process_physics(delta: float) -> void:
	if not player: return
	
	# -------------STATE LOGIC-------------
	
	if player.velocity.y < 0.0:
		apply_gravity(delta)
	else:
		player.velocity.y += player.rise_gravity * player.wall_slide_gravity_multiplier * delta
		player.velocity.y = minf(player.velocity.y, player.wall_slide_max_fall_speed)
	
	# -------------TRANSITION LOGIC-------------
	
	if Input.is_action_just_pressed("jump"):
		_state_machine.transition_to("WallJump")
		return
	
	if player.is_on_floor():
		_state_machine.transition_to("Idle")
		return

	if not is_on_wall_and_pressing():
		player.wall_coyote_timer = player.wall_coyote_time
		_state_machine.transition_to("Fall")
		return
