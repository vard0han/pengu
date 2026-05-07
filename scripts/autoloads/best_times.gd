extends Node

const SAVE_PATH: String = "user://best_times.json"

var times: Dictionary = {}

func _ready() -> void:
	_load()

func _load() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		times = {}
		return
	
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Failed to open best times file for reading")
		return
	
	var content: String = file.get_as_text()
	file.close()
	
	var parsed: Dictionary = JSON.parse_string(content)
	if parsed is Dictionary:
		times = parsed
	else:
		push_warning("Best times file invalid, resetting")
		times = {}

func _save() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open best times file for writing")
		return
	
	file.store_string(JSON.stringify(times))
	file.close()

func get_best_time(level_id: String) -> float:
	if level_id in times:
		return times[level_id]
	return INF # no record means any time is a new best

func record_time(level_id: String, time: float) -> bool:
	var current_best: float = get_best_time(level_id)
	
	if time < current_best:
		times[level_id] = time
		_save()
		return true
	
	return false
