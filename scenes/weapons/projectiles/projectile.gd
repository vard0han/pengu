class_name Projectile
extends Area2D

@export var damage: int = 1
@export var lifetime: float = 5.0

var max_distance: float = 1000.0
var velocity: Vector2 = Vector2.ZERO
var _distance_travelled: float = 0.0 # range checks against this

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	var step: Vector2 = velocity * delta
	global_position += step
	_distance_travelled += step.length()
	
	if _distance_travelled >= max_distance:
		queue_free()
		return
	
	_tick_lifetime(delta)

func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		body.take_damage(damage)
	
	queue_free()

func _tick_lifetime(delta: float) -> void:
	lifetime -= delta
	
	if lifetime <= 0:
		queue_free()
