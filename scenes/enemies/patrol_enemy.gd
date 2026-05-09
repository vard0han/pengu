class_name PatrolEnemy
extends Enemy

@export var patrol_speed : float = 50.0
@export var gravity : float = 800.0

var direction : int = -1

@onready var ledge_ray: RayCast2D = $LedgeRay
@onready var sprite: Sprite2D = $Sprite2D
@onready var health_bar: EnemyHealthBar = %EnemyHealthBar

func _ready() -> void:
	super._ready()
	health_component.health_changed.connect(_on_health_changed)
	health_bar.setup(health_component.max_health)

func _on_health_changed(current: int, _max: int) -> void:
	health_bar.update_health(current)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = patrol_speed * direction
	
	move_and_slide()
	
	# when we hit a wall, or when we are on floor and raycast doesn't collide with anything flip the direction
	if is_on_wall():
		flip_direction()
	elif not ledge_ray.is_colliding() and is_on_floor():
		flip_direction()

func flip_direction() -> void:
	# flip direction and in which direction the raycast detects the collision
	direction *= -1
	ledge_ray.position.x *= -1
	
	sprite.flip_h = direction > 0
	
	# Force immediate update — raycast state is stale for one frame after moving it
	ledge_ray.force_raycast_update()
