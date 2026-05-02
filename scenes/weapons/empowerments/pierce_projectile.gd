class_name PierceProjectile
extends Projectile

var _hit_enemies: Array[Enemy] = []

func _on_body_entered(body: Node) -> void:
	if body is Enemy and not body in _hit_enemies:
		body.take_damage(damage)
		_hit_enemies.append(body)
