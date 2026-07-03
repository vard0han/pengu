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

func apply_horizontal_movement(delta: float) -> void:
	if not player:
		return
	
	var target_speed : float = player.move_speed * player.direction
	
	# move towards the target speed at the rate of acceleration, when direction is known
	# move towards 0 speed at the rate of deceleration, when direction input not held
	if player.direction != 0:
		player.velocity.x = move_toward(player.velocity.x, target_speed, player.acceleration * delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.deceleration * delta)
