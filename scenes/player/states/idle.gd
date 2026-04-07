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
	
	var on_floor := player.is_on_floor()
	var direction : float = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_just_pressed("jump") and on_floor:
		state_machine.transition_to("Jump")
		return
	
	if not on_floor and player.velocity.y > 0:
		state_machine.transition_to("Fall")
		return
	
	if(direction != 0):
		state_machine.transition_to("Run")
		return
