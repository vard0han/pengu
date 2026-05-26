class_name GameOver
extends Control

@onready var retry_button: Button = %RetryButton
@onready var main_menu_button: Button = %MainMenuButton


signal retry_pressed

func _ready() -> void:
	retry_button.pressed.connect(func() -> void: retry_pressed.emit())
	main_menu_button.pressed.connect(func() -> void: Main.get_instance(get_tree()).show_level_select())
