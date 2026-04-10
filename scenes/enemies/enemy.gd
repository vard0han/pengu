class_name Enemy
extends CharacterBody2D

@export var max_health: int = 1
@export var contact_damage : int = 1
@export var card_drop : PackedScene


var current_health : int

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	current_health -= amount
	die()

func die() -> void:
	print("Enemy died")
	var card = card_drop.instantiate()
	card.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", card)
	queue_free()
