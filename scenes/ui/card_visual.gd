@tool
class_name CardVisual
extends PanelContainer

@onready var icon_rect: TextureRect = %IconRect
@onready var label_text: Label = %LabelText

var _card: CardData = null

func _ready() -> void:
	set_card(_card, true)

func set_card(card: CardData, with_label: bool) -> void:
	_card = card
	
	if not is_node_ready():
		return
	
	if card == null:
		_show_empty()
	elif with_label:
		show_card_with_label(card)
	else:
		show_card(card)

func _show_empty() -> void:
	icon_rect.texture = null
	label_text.text = ""
	_set_panel_color(Color(0.2, 0.2, 0.2, 0.5))

func show_card_with_label(card: CardData) -> void:
	icon_rect.texture = card.icon
	label_text.text = card.display_label
	_set_panel_color(card.color)

func show_card(card: CardData) -> void:
	icon_rect.texture = card.icon
	
	# make label invisible so icon gets centered on pickup
	label_text.visible = false
	
	_set_panel_color(card.color)

func _set_panel_color(color: Color) -> void:
	var style: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	style.bg_color = color
	add_theme_stylebox_override("panel", style)
