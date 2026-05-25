class_name TurretBullet
extends Area2D

@export var speed: float = 200.0
@export var damage: int = 1
@export var max_distance: float = 0.0

var _velocity: Vector2 = Vector2.ZERO
var _distance_traveled: float = 0.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func launch(direction: Vector2) -> void:
	_velocity = direction.normalized() * speed

func _process(delta: float) -> void:
	global_position += _velocity * delta
	_distance_traveled += _velocity.length() * delta
	if _distance_traveled >= max_distance:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if not area is Hurtbox:
		return
	area.health_component.take_damage(damage)
	queue_free()
