extends Node

const SAVE_PATH: String = "user://save_data.json"

var data: Dictionary = {}

func _ready() -> void:
	_load()

func _load() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		data = {}
		return
	
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Failed to open best times file for reading")
		return
	
	var content: String = file.get_as_text()
	file.close()
	
	var parsed: Dictionary = JSON.parse_string(content)
	if parsed is Dictionary:
		data = parsed
	else:
		push_warning("Best times file invalid, resetting")
		data = {}

func _save() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open best times file for writing")
		return
	
	file.store_string(JSON.stringify(data))
	file.close()

func _get_level_data(level_id: String) -> Dictionary:
	if level_id not in data:
		data[level_id] = {}
	return data[level_id]

func get_best_time(level_id: String) -> float:
	return _get_level_data(level_id).get("best_time", INF)

func get_best_medal(level_id: String) -> int:
	return _get_level_data(level_id).get("best_medal", 0)

func record_time(level_id: String, time: float) -> bool:
	var current_best: float = get_best_time(level_id)
	
	if time < current_best:
		_get_level_data(level_id)["best_time"] = time
		_save()
		return true
	
	return false

func record_medal(level_id: String, medal: int) -> bool:
	var current_best: int = get_best_medal(level_id)
	
	if medal > current_best:
		_get_level_data(level_id)["best_medal"] = medal
		_save()
		return true
	
	return false
