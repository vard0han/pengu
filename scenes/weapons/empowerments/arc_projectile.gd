class_name ArcProjectile
extends Projectile
@export var gravity_strength: float = 600.0
@export var min_lift: float = 40.0

static func compute_launch_velocity(from: Vector2, target: Vector2, gravity_param: float, min_lift_value: float) -> Vector2:
	var dx: float = target.x - from.x
	var dy: float = target.y - from.y
	var rise: float = max(-dy, min_lift_value)
	var vy: float = -sqrt(2.0 * gravity_param * rise)
	var time_to_peak: float = -vy / gravity_param
	var vx: float = dx / time_to_peak
	return Vector2(vx, vy)

func _ready() -> void:
	super._ready()

func launch_arc(from: Vector2, target: Vector2) -> void:
	global_position = from
	velocity = compute_launch_velocity(from, target, gravity_strength, min_lift)


func _physics_process(delta: float) -> void:
	velocity.y += gravity_strength * delta
	global_position += velocity * delta
	if velocity.length() > 0:
		rotation = velocity.angle()
	_tick_lifetime(delta)
