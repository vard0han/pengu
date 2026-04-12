class_name CardPickup
extends Area2D

@export var card_data: CardData

func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.collect_card(card_data)
		queue_free()
