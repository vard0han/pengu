class_name GameOver
extends Control

@onready var retry_button: Button = %RetryButton

signal retry_pressed

func _ready() -> void:
	retry_button.pressed.connect(func() -> void: retry_pressed.emit())
