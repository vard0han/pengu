class_name LevelTitleCard
extends Control

@onready var title_label: Label = %Label

func _ready() -> void:
	modulate.a = 0.0

func show_title(level_name: String, duration: float) -> void:
	title_label.text = level_name
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	tween.tween_interval(duration - 0.6)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	
	await tween.finished
	queue_free()
