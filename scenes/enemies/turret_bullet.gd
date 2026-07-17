class_name TurretBullet
extends Area2D

@export var speed: float = 200.0
@export var max_distance: float = 0.0

var _velocity: Vector2 = Vector2.ZERO
var _distance_traveled: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func launch(direction: Vector2) -> void:
	_velocity = direction.normalized() * speed

func _physics_process(delta: float) -> void:
	global_position += _velocity * delta
	_distance_traveled += _velocity.length() * delta
	if _distance_traveled >= max_distance:
		queue_free()

func _on_body_entered(_body: Node) -> void:
	queue_free()
