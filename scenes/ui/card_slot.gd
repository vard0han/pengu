class_name CardSlot
extends Control

@onready var card_visual: CardVisual = %CardVisual

func set_card(card: CardData) -> void:
	card_visual.set_card(card, true)
