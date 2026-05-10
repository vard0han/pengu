class_name HeartsDisplay
extends HBoxContainer

@export var full_heart_texture: Texture2D
@export var empty_heart_texture: Texture2D

var _heart_rects: Array[TextureRect] = []

func setup(max_health: int) -> void:
	for rect: TextureRect in _heart_rects:
		rect.queue_free()
	_heart_rects.clear()
	
	for i: int in range(max_health):
		var rect : TextureRect = TextureRect.new()
		rect.texture = full_heart_texture
		rect.custom_minimum_size = Vector2(32,32)
		rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		add_child(rect)
		_heart_rects.append(rect)

func update_health(current_health: int) -> void:
	for i: int in range(_heart_rects.size()):
		if i < current_health:
			_heart_rects[i].texture = full_heart_texture
		else:
			_heart_rects[i].texture = empty_heart_texture
