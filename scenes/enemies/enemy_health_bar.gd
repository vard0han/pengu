class_name EnemyHealthBar
extends HBoxContainer

const CHUNK_SCENE: PackedScene = preload("res://scenes/enemies/health_chunk.tscn")

var _chunks: Array[Panel] = []

func setup(max_health: int) -> void:
	for chunk: Panel in _chunks:
		chunk.queue_free()
	_chunks.clear()
	
	for i: int in range(max_health):
		var chunk: Panel = CHUNK_SCENE.instantiate()
		add_child(chunk)
		_chunks.append(chunk)

func update_health(current_health: int) -> void:
	while _chunks.size() > current_health:
		var removed: Panel = _chunks.pop_back()
		removed.queue_free()
