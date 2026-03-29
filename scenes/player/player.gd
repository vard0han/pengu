extends CharacterBody2D

@export_category("Horizontal Movement")
@export var move_speed : float = 100.0
@export var acceleration : float = 1000.0
@export var deceleration : float = 800.0

@export_category("Vertical Movement")
@export var jump_force : float = 300.0
@export var gravity : float = 800.0
@export var jump_cut_multiplier : float = 0.4
@export var max_fall_speed : float = 800.0

@onready var _anim_player : AnimationPlayer = $AnimationPlayer
@onready var _sprite : Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	# increase gravity each frame, while mid-air
	if not is_on_floor():
		velocity.y += gravity * delta
		# stop gravity from reaching stupid number (might cause bugs)
		velocity.y = minf(velocity.y, max_fall_speed)
	
	# apply negative velocity upwards when jump button is pressed, while on floor
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
	
	# when jump is released and we are moving up
	# we cut the upwards velocity by the multiplier
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_cut_multiplier
	
	# get direction and apply velocity with movement speed in that direction
	var direction : float = Input.get_axis("move_left", "move_right")
	
	# when direction exists, handle sprite flip when facing left and right
	if(direction != 0):
		_sprite.flip_h = direction > 0
	
	var target_speed : float = move_speed * direction
	
	# move towards the target speed at the rate of acceleration, when direction is known
	# move towards 0 speed at the rate of deceleration, when direction input not held
	if direction != 0:
		velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
	
	move_and_slide()
	
	_update_animation()

func _update_animation() -> void:
	if not is_on_floor():
		_anim_player.play("air")
	# velocity sometimes reaches really low numbers, to avoid animation flickering
	# we only trigger run on higher than 0.1 velocity
	elif absf(velocity.x) > 0.1:
		_anim_player.play("run")
	else:
		_anim_player.play("idle")
