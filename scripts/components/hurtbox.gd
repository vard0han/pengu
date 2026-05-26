class_name Hurtbox
extends Area2D

@export var health_component: HealthComponent

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
	if health_component == null:
		push_warning("Hurtbox has no HealthComponent assigned")

func _on_area_entered(area: Area2D) -> void:
	if not (area is Hitbox):
		return
	if health_component == null:
		return
	
	var hitbox: Hitbox = area
	health_component.take_damage(hitbox.damage)
	
	if get_parent() is Enemy:
		AudioManager.play_sfx("enemy_hit", -20.0, randf_range(0.9, 1.0))
	if get_parent() is Player:
		AudioManager.play_sfx("player_hit", -10.0, randf_range(1.15, 1.25))
	
	if hitbox.destroy_on_hit:
		var source: Node = hitbox.get_parent()
		if source and is_instance_valid(source):
			source.queue_free()
