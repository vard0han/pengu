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
	
	# increase gravity each frame, while mid-air
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta
		# stop gravity from reaching stupid number (might cause bugs)
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
