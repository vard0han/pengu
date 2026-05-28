class_name Enemy
extends CharacterBody2D

const CARD_PICKUP_SCENE: PackedScene = preload("res://scenes/cards/card_pickup.tscn")

@export var card_drop : CardData
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: EnemyHealthBar = %EnemyHealthBar
@onready var sprite: Node2D = $Sprite2D

const DEATH_BURST_SCENE: PackedScene = preload("res://scenes/effects/particles/enemy_death_burst.tscn")

func _ready() -> void:
	health_component.health_changed.connect(_on_health_changed)
	health_bar.setup(health_component.max_health)
	health_component.damage_cooldown = 0.05
	health_component.died.connect(_on_died)
	
	if card_drop:
		_apply_outline_color(card_drop.color)

func _on_died() -> void:
	AudioManager.play_sfx("enemy_hit", -15.0, randf_range(1.5, 1.7))
	
	var main: Main = Main.get_instance(get_tree())
	if main and main.current_player:
		main.current_player.shake_camera("small")
	
	_spawn_death_burst()
	_drop_card()
	queue_free()

func _spawn_death_burst() -> void:
	var main: Main = Main.get_instance(get_tree())
	if main and main.current_level:
		var card_drop_color: Color = card_drop.color if card_drop else Color.WHITE
		main.game_manager.spawn_particle(DEATH_BURST_SCENE, sprite.global_position, card_drop_color)

func _on_health_changed(current: int, _max: int) -> void:
	health_bar.update_health(current)

func _drop_card() -> void:
	# if scene exists, instantiate it, adjust the position
	# add it in the level scene tree, remove the enemy
	if card_drop:
		var card_pickup: Node = CARD_PICKUP_SCENE.instantiate()
		card_pickup.card_data = card_drop
		card_pickup.global_position = global_position
		
		var main : Main = Main.get_instance(get_tree())
		var container : Node2D = main.game_manager.get_pickups_container()
		if container:
			container.call_deferred("add_child", card_pickup)

func _apply_outline_color(color: Color) -> void:
	sprite.material.set_shader_parameter("outline_color", color)
