extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func fade_to_black(duration: float = 0.3) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(color_rect, "color:a", 1.0, duration)
	await tween.finished

func fade_from_black(duration: float = 0.3) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0.0, duration)
	await tween.finished
