class_name Enemy
extends CharacterBody2D

@export var card_drop_scene : PackedScene
@export var card_drop : CardData
@onready var health_component: HealthComponent = $HealthComponent

func _ready() -> void:
	health_component.damage_cooldown = 0.05
	health_component.died.connect(_on_died)

func _on_died() -> void:
	_drop_card()
	queue_free()

func _drop_card() -> void:
	# if scene exists, instantiate it, adjust the position
	# add it in the level scene tree, remove the enemy
	if card_drop_scene:
		var card_pickup: Node = card_drop_scene.instantiate()
		card_pickup.card_data = card_drop
		card_pickup.global_position = global_position
		
		var main : Main = Main.get_instance(get_tree())
		var container : Node2D = main.game_manager.get_pickups_container()
		if container:
			container.call_deferred("add_child", card_pickup)
