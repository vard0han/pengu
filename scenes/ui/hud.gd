class_name HUD
extends Control

@onready var card_slot_0: CardSlot = %CardSlot0
@onready var card_slot_1: CardSlot = %CardSlot1
@onready var empowerment_label: Label = %EmpowermentLabel

func _ready() -> void:
	empowerment_label.visible = false

func refresh_inventory(cards: Array) -> void:
	card_slot_0.set_card(cards[0] if cards.size() > 0 else null)
	card_slot_1.set_card(cards[1] if cards.size() > 1 else null)

func set_empowered(is_empowered: bool, card: CardData = null) -> void:
	empowerment_label.visible = is_empowered
	if is_empowered and card:
		empowerment_label.text = "EMPOWERED: " + card.display_label
	else:
		empowerment_label.text = ""
