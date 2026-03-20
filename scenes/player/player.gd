extends CharacterBody2D

@export var move_speed : float = 100.0
@export var jump_force : float = 250.0
@export var gravity : float = 800.0

var max_falling_speed : float = 800.0


func _physics_process(delta):
	# Increase gravity each frame, while mid-air
	if not is_on_floor():
		velocity.y += gravity * delta
		# stop gravity from reaching stupid number (might cause bugs)
		velocity.y = min(velocity.y, max_falling_speed)
	
	# Apply negative velocity upwards when jump button is pressed, while on floor
	if(Input.is_action_just_pressed("jump")) and is_on_floor():
		velocity.y = -jump_force
	
	# Get direction and apply velocity with movement speed in that direction
	var direction : float = Input.get_axis("move_left", "move_right")
	velocity.x = move_speed * direction
	
	move_and_slide()
