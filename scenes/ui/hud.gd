class_name HUD
extends Control

@onready var card_slot_0: CardSlot = %CardSlot0
@onready var card_slot_1: CardSlot = %CardSlot1
@onready var empowerment_label: Label = %EmpowermentLabel
@onready var enemies_label: Label = %EnemiesLabel
@onready var timer_label: Label = %TimerLabel

var active_level: Level = null

func _ready() -> void:
	empowerment_label.visible = false
	update_enemies_remaining(0)

func set_active_level(level: Level) -> void:
	active_level = level

func _process(_delta: float) -> void:
	if active_level:
		update_timer(active_level.time_elapsed)

func update_enemies_remaining(count: int) -> void:
	if count <= 0:
		enemies_label.modulate = Color(0.4, 1.0, 0.4)
	else:
		enemies_label.modulate = Color.WHITE
	
	enemies_label.text = str(count)

func update_timer(time_seconds: float) -> void:
	timer_label.text = "%.2f" % time_seconds

func refresh_inventory(cards: Array) -> void:
	card_slot_0.set_card(cards[0] if cards.size() > 0 else null)
	card_slot_1.set_card(cards[1] if cards.size() > 1 else null)

func set_empowered(is_empowered: bool, card: CardData = null) -> void:
	empowerment_label.visible = is_empowered
	if is_empowered and card:
		empowerment_label.text = "EMPOWERED: " + card.display_label
	else:
		empowerment_label.text = ""
