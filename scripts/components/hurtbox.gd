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
	
	if hitbox.destroy_on_hit:
		hitbox.queue_free()
