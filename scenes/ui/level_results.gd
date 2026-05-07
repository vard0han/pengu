class_name LevelResults
extends Control

@onready var time_label: Label = %TimeLabel
@onready var best_label: Label = %BestLabel
@onready var continue_button: Button = %ContinueButton

signal continue_pressed

func _ready() -> void:
	continue_button.pressed.connect(func() -> void: continue_pressed.emit())

func setup(level_time: float, best_time: float, is_new_best: bool) -> void:
	time_label.text = "TIME: %.2f" % level_time
	
	if is_new_best:
		best_label.text = "NEW BEST!"
		best_label.modulate = Color(1.0, 0.85, 0.3)
	else:
		best_label.text = "BEST: %.2f" % best_time
		best_label.modulate = Color.WHITE
