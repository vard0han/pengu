class_name ArcProjectile
extends Projectile

@export var gravity_strength: float = 600.0
@export var min_lift: float = 0.0

func _ready() -> void:
	super._ready()
	
	var target: Vector2 = get_global_mouse_position()
	var dx: float = target.x - global_position.x
	var dy: float = target.y - global_position.y
	
	var rise: float = max(-dy, min_lift)
	var vy_initial: float = -sqrt(2.0 * gravity_strength * rise)
	var time_to_peak: float = -vy_initial / gravity_strength
	var vx_initial: float = dx / time_to_peak
	
	velocity = Vector2(vx_initial, vy_initial)

func _physics_process(delta: float) -> void:
	velocity.y += gravity_strength * delta
	global_position += velocity * delta
	
	if velocity.length() > 0:
		rotation = velocity.angle()
	
	_tick_lifetime(delta)
