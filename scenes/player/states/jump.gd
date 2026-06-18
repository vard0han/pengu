class_name JumpState
extends PlayerState

const JUMP_PUFF_SCENE: PackedScene = preload("res://scenes/effects/particles/jump_puff.tscn")

func enter() -> void:
	super()
	player.velocity.y = -1 * player.jump_force
	
	player.sprite.play("jump")
	
	AudioManager.play_sfx("jump", -10.0 ,randf_range(0.8, 1.0))
	_spawn_jump_puff()

func process_physics(delta: float) -> void:
	if not player: return
	
	# -------------STATE LOGIC-------------
	
	apply_horizontal_movement(delta)
	apply_gravity(delta)
	
	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y *= player.jump_cut_multiplier
	
	# -------------TRANSITION LOGIC-------------
	
	if player.velocity.y >= 0:
		_state_machine.transition_to("Fall")
		return

func _spawn_jump_puff() -> void:
	var main: Main = Main.get_instance(player.get_tree())
	if main:
		main.game_manager.spawn_particle(JUMP_PUFF_SCENE, player.global_position + Vector2(0,4))
