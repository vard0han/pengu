extends Control

const LEVEL_3_PATH: String = "res://scenes/world/levels/level_03.tscn"

@onready var _level1_button: Button = %Level1Button
@onready var _level2_button: Button = %Level2Button
@onready var _level3_button: Button = %Level3Button
@onready var _back_button: Button = %BackButton

func _ready() -> void:
	_level1_button.pressed.connect(_on_level1_pressed)
	_level2_button.pressed.connect(_on_level2_pressed)
	_level3_button.pressed.connect(_on_level3_pressed)
	_back_button.pressed.connect(_on_back_pressed)

	# Visually mark unimplemented levels as disabled
	_level1_button.disabled = true
	_level2_button.disabled = true

func _on_level1_pressed() -> void:
	pass

func _on_level2_pressed() -> void:
	pass

func _on_level3_pressed() -> void:
	Main.get_instance(get_tree()).start_level(LEVEL_3_PATH)

func _on_back_pressed() -> void:
	Main.get_instance(get_tree()).show_main_menu()
