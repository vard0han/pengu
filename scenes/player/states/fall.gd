class_name FallState
extends PlayerState

const LANDING_PUFF_SCENE: PackedScene = preload("res://scenes/effects/particles/landing_puff.tscn")

func enter() -> void:
	super()
	player.sprite.play("fall")

func process_physics(delta: float) -> void:
	if not player: return
	
	# -------------STATE LOGIC-------------
	
	apply_horizontal_movement(delta)
	apply_gravity(delta)
	
	# -------------TRANSITION LOGIC-------------

	if is_on_wall_and_pressing():
		player.wall_normal = player.get_wall_normal()
		_state_machine.transition_to("WallSlide")
		return

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

	if Input.is_action_just_pressed("jump") and player.wall_coyote_timer > 0.0:
		player.wall_coyote_timer = 0.0
		_state_machine.transition_to("WallJump")
		return

func exit() -> void:
	if player.is_on_floor():
		_spawn_landing_puff()

func _spawn_landing_puff() -> void:
	var main: Main = Main.get_instance(player.get_tree())
	if main:
		main.game_manager.spawn_particle(LANDING_PUFF_SCENE, player.global_position + Vector2(0, 8))
