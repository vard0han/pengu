class_name Enemy
extends CharacterBody2D

@export var max_health: int = 1
@export var contact_damage : int = 1
@export var card_drop_scene : PackedScene
@export var card_drop : CardData

var current_health : int

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	current_health -= amount
	die()

func die() -> void:
	print("Enemy died")
	
	# if scene exists, instantiate it, adjust the position
	# add it in the level scene tree, remove the enemy
	if card_drop_scene:
		var card_pickup = card_drop_scene.instantiate()
		card_pickup.card_data = card_drop
		card_pickup.global_position = global_position
		get_tree().current_scene.get_node("Pickups").call_deferred("add_child", card_pickup)
		queue_free()
