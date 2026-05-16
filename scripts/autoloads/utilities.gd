extends Node

func format_time(seconds: float) -> String:
	if seconds < 60.0:
		return "%.2f" % seconds
	
	var minutes: int = int(seconds / 60)
	var remaining_seconds: float = fmod(seconds, 60.0)
	return "%d:%05.2f" % [minutes, remaining_seconds]
