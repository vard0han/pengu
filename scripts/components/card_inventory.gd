class_name CardInventory
extends Node

const MAX_SLOTS: int = 2

signal card_added(card: CardData, slot_index: int)
signal card_removed(card: CardData, slot_index: int)
signal inventory_full
signal card_cycled

signal card_used(card: CardData)
signal card_sacrificed(card: CardData)

var cards: Array[CardData] = []

func add_card(card: CardData) -> bool:
	if cards.size() >= MAX_SLOTS:
		inventory_full.emit()
		return false
	
	cards.append(card)
	card_added.emit(card, cards.size() - 1)
	
	#_print_state()
	
	return true

func remove_card(slot_index: int) -> CardData:
	if slot_index >= MAX_SLOTS:
		return null
	
	var card: CardData = cards[slot_index]
	cards.remove_at(slot_index)
	
	card_removed.emit(card, slot_index)
	
	#_print_state()
	
	return card

func use_card(slot_index: int) -> CardData:
	if slot_index >= MAX_SLOTS:
		return null
	
	var card: CardData = get_card(slot_index)
	remove_card(slot_index)
	
	card_used.emit(card)
	
	return card

func sacrifice_card(slot_index: int) -> CardData:
	if slot_index >= MAX_SLOTS:
		return null
	
	var card: CardData = get_card(slot_index)
	remove_card(slot_index)
	
	card_sacrificed.emit(card)
	
	return card

func cycle_card() -> void:
	cards.reverse()
	
	card_cycled.emit()

# HELPER FUNCTIONS

func is_full() -> bool:
	return cards.size() >= MAX_SLOTS

func get_card(slot_index: int) -> CardData:
	if slot_index >= MAX_SLOTS:
		return null
	
	return cards[slot_index]

func _print_state() -> void:
	if cards.size() > 0:
		print("Inventory: ")
		for card : CardData in cards:
			print(card.card_name)
	else:
		print("Empty")
