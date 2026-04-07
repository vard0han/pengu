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
	
	var on_floor := player.is_on_floor()
	var direction : float = Input.get_axis("move_left", "move_right")
	
	if on_floor and absf(player.velocity.x) < 0.1:
		state_machine.transition_to("Idle")
		return
	
	if on_floor and direction != 0:
		state_machine.transition_to("Run")
		return
