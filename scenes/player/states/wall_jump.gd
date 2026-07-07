class_name WallJumpState
extends PlayerState

const JUMP_PUFF_SCENE: PackedScene = preload("res://scenes/effects/particles/jump_puff.tscn")

func enter() -> void:
	super()
	player.velocity.y = -player.wall_jump_velocity
	player.velocity.x = player.wall_normal.x * player.wall_jump_horizontal_speed
	player.wall_jump_lock_timer = player.wall_jump_lock_time
	player.sprite.play("jump")
	AudioManager.play_sfx("jump", -10.0, randf_range(0.9, 1.1))
	_spawn_jump_puff()

func process_physics(delta: float) -> void:
	if not player: return
	
	# -------------STATE LOGIC-------------
	
	apply_corner_correction(delta)
	
	if player.wall_jump_lock_timer <= 0.0:
		apply_horizontal_movement(delta)
	
	apply_gravity(delta)
	
	# -------------TRANSITION LOGIC-------------
	
	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y *= player.jump_cut_multiplier
	
	if is_on_wall_and_pressing():
		player.wall_normal = player.get_wall_normal()
		_state_machine.transition_to("WallSlide")
		return
	
	if player.velocity.y >= 0:
		_state_machine.transition_to("Fall")
		return

	if player.is_on_floor():
		_state_machine.transition_to("Run" if absf(player.velocity.x) > 0.1 else "Idle")
		return

func _spawn_jump_puff() -> void:
	var main: Main = Main.get_instance(player.get_tree())
	if main:
		main.game_manager.spawn_particle(JUMP_PUFF_SCENE, player.global_position + Vector2(0, 4))
