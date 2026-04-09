class_name Enemy
extends CharacterBody2D

@export var max_health: int = 1
@export var contact_damage : int = 1
@export var card_drop : Resource

var current_health : int

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	current_health -= amount
	die()

func die() -> void:
	print("Enemy died")
	# TODO: spawn card_drop at position before freeing
	queue_free()
