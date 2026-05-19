class_name HUD
extends Control

@onready var card_slot_0: CardSlot = %CardSlot0
@onready var card_slot_1: CardSlot = %CardSlot1
@onready var enemies_label: Label = %EnemiesLabel
@onready var timer_label: Label = %TimerLabel
@onready var hearts_display: HeartsDisplay = %HeartsDisplay

var active_level: Level = null

func _ready() -> void:
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
	timer_label.text = Utilities.format_time(time_seconds)

func refresh_inventory(cards: Array) -> void:
	card_slot_0.set_card(cards[0] if cards.size() > 0 else null)
	card_slot_1.set_card(cards[1] if cards.size() > 1 else null)

func setup_player_hearts(max_health: int) -> void:
	hearts_display.setup(max_health)

func update_player_hearts(current_health: int) -> void:
	hearts_display.update_health(current_health)

func shake_inventory() -> void:
	for card_slot : Control in %CardSlotsRow.get_children():
		card_slot.pivot_offset = card_slot.size / 2.0
		
		var tween: Tween = create_tween()
		tween.tween_property(card_slot, "rotation_degrees", 5.0, 0.05)
		tween.tween_property(card_slot, "rotation_degrees", -5.0, 0.05)
		tween.tween_property(card_slot, "rotation_degrees", 3.0, 0.05)
		tween.tween_property(card_slot, "rotation_degrees", 0.0, 0.05)
