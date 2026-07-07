class_name PlayerState
extends State

var player : Player

func enter() -> void:
	player = actor as Player

func process_physics(_delta: float) -> void:
	pass

func apply_gravity(delta: float) -> void:
	if not player:
		return
	if player.is_on_floor():
		return
	
	var g: float
	
	if absf(player.velocity.y) < player.apex_threshold:
		g = player.rise_gravity * player.apex_gravity_multiplier
	elif player.velocity.y < 0.0:
		g = player.rise_gravity
	else:
		g = player.fall_gravity
	
	player.velocity.y += g * delta
	player.velocity.y = minf(player.velocity.y, player.max_fall_speed)

func is_on_wall_and_pressing() -> bool:
	if not player: return false
	if not player.is_on_wall_only(): return false
	if player.wall_jump_lock_timer > 0.0: return false
	var wall_dir: float = -player.get_wall_normal().x
	return player.direction == signf(wall_dir)

func apply_horizontal_movement(delta: float) -> void:
	if not player:
		return
	
	if player.direction != 0:
		var target_speed: float = player.move_speed * player.direction
		var accel: float = player.acceleration
	
		if player.velocity.x != 0.0 and signf(player.velocity.x) != signf(player.direction):
			accel *= player.turn_acceleration_multiplier
	
		player.velocity.x = move_toward(player.velocity.x, target_speed, accel * delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, player.deceleration * delta)
	
	player.velocity.x = clampf(player.velocity.x, -player.max_horizontal_speed, player.max_horizontal_speed)


func apply_corner_correction(delta: float) -> void:
	if not player:
		return
	if player.velocity.y >= 0.0:
		return
	
	var motion: Vector2 = Vector2(0, player.velocity.y * delta)
	
	if not player.test_move(player.global_transform, motion):
		return
	
	for nudge_dir : float in [1.0, -1.0]:
		var nudge: Vector2 = Vector2(player.corner_correction_distance * nudge_dir, 0)
		var nudged_transform: Transform2D = player.global_transform.translated(nudge)

		if not player.test_move(nudged_transform, motion):
			player.global_position += nudge
			return

# ---------- Timing forgiveness: shared contract ----------

## Call this to check if a ground jump is available via coyote time.
func can_coyote_jump() -> bool:
	return player.coyote_timer > 0.0

## Consumes both timers and transitions to Jump. Call after can_coyote_jump() returns true.
func do_coyote_jump() -> void:
	player.coyote_timer = 0.0
	player.jump_buffer_timer = 0.0
	_state_machine.transition_to("Jump")

## Call this to check if a buffered jump is waiting to fire, typically on landing.
func has_buffered_jump() -> bool:
	return player.jump_buffer_timer > 0.0

## Consumes both timers and transitions to Jump. Call after has_buffered_jump() returns true.
func do_buffered_jump() -> void:
	player.jump_buffer_timer = 0.0
	player.coyote_timer = 0.0
	_state_machine.transition_to("Jump")

## Call from a grounded state right before handing off to Fall (walking off a ledge).
func start_coyote_time() -> void:
	player.coyote_timer = player.coyote_time

## Call when a direct, on-floor jump input fires. Clears buffer so it can't double-fire later.
func consume_direct_jump_input() -> void:
	player.jump_buffer_timer = 0.0
