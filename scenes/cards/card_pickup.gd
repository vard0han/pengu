class_name CardPickup
extends Area2D

@export var card_data: CardData
@onready var card_visual: CardVisual = $CardVisual

func _ready() -> void:
	card_visual.set_card(card_data, false)

func _on_body_entered(body: Node) -> void:
	if body is Player:
		var added: bool = body.card_inventory.add_card(card_data)
		if added:
			queue_free()
