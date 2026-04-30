class_name Projectile
extends Area2D

@export var damage: int = 1
@export var lifetime: float = 3.0
@export var base_speed: float = 300.0

var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	var aim_dir: Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	velocity = aim_dir * base_speed

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	
	_tick_lifetime(delta)

func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		body.take_damage(damage)
	
	queue_free()

func _tick_lifetime(delta: float) -> void:
	lifetime -= delta
	
	if lifetime <= 0:
		queue_free()
