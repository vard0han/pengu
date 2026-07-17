@tool
class_name CardPickup
extends Area2D

@export var card_data: CardData : set = _set_card_data
@onready var card_visual: CardVisual = $CardVisual

const PICKUP_SPARKLE_SCENE: PackedScene = preload("res://scenes/effects/particles/card_pickup_sparkle.tscn")

func _ready() -> void:
	card_visual.set_card(card_data, false)

func _set_card_data(value: CardData) -> void:
	card_data = value
	if is_node_ready():
		card_visual.set_card(card_data, false)

func _on_body_entered(body: Node) -> void:
	if not body is Player:
		return
	
	var added: bool = body.card_inventory.add_card(card_data)
	if not added:
		return
	
	_spawn_sparkle()
	queue_free()

func _spawn_sparkle() -> void:
	var main: Main = Main.get_instance(get_tree())
	if main and main.current_level:
		var card_data_color: Color = card_data.color if card_data else Color.WHITE
		main.game_manager.spawn_particle(PICKUP_SPARKLE_SCENE, global_position, card_data_color)
