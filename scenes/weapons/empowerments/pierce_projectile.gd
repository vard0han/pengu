class_name PierceProjectile
extends Projectile

func on_launched() -> void:
	velocity = (velocity * 2).limit_length(1000.0)

func _on_body_entered(_body: Node) -> void:
	pass
