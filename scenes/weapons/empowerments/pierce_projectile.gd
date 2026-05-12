class_name PierceProjectile
extends Projectile

func _ready() -> void:
	velocity = (velocity * 2).limit_length(1000.0)
