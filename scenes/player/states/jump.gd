class_name JumpState
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
	
	if player.velocity.y >= 0:
		state_machine.transition_to("Fall")
		return
