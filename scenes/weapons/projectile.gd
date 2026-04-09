class_name Projectile
extends Area2D

@export var speed : float = 400.0
@export var damage : int = 1
@export var lifetime : float = 3

var direction : Vector2 = Vector2.RIGHT
var lifetime_counter : float = 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	lifetime_counter += delta
	
	if lifetime_counter >= lifetime:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		body.take_damage(damage)
	
	queue_free()
