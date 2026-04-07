class_name PlayerState
extends State

var player : Player

func enter() -> void:
	player = actor as Player

func process_physics(_delta) -> void:
	pass

func apply_gravity(delta):
	if not player:
		return
	
	# increase gravity each frame, while mid-air
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta
		# stop gravity from reaching stupid number (might cause bugs)
		player.velocity.y = minf(player.velocity.y, player.max_fall_speed)

func apply_horizontal_movement(delta):
	if not player:
		return
	
	var direction : float = Input.get_axis("move_left", "move_right")
	
	var target_speed : float = player.move_speed * direction
	
	# move towards the target speed at the rate of acceleration, when direction is known
	# move towards 0 speed at the rate of deceleration, when direction input not held
	if direction != 0:
		# when direction exists, handle sprite flip when facing left and right
		player.sprite.flip_h = direction > 0
		
		player.velocity.x = move_toward(player.velocity.x, target_speed, player.acceleration * delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.deceleration * delta)
