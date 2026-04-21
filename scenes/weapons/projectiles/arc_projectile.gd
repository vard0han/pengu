class_name ArcProjectile
extends Projectile

@export var gravity_strength: float = 600.0
@export var min_lift: float = 0.0

func _ready() -> void:
	super._ready()
	
	var target = get_global_mouse_position()
	var dx = target.x - global_position.x
	var dy = target.y - global_position.y
	
	var rise = max(-dy, min_lift)
	var vy_initial = -sqrt(2.0 * gravity_strength * rise)
	var time_to_peak = -vy_initial / gravity_strength
	var vx_initial = dx / time_to_peak
	
	velocity = Vector2(vx_initial, vy_initial)

func _physics_process(delta: float) -> void:
	velocity.y += gravity_strength * delta
	global_position += velocity * delta
	
	if velocity.length() > 0:
		rotation = velocity.angle()
	
	_tick_lifetime(delta)
