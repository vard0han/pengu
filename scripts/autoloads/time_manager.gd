extends Node

func hitstop(duration: float, time_scale: float = 0.0) -> void:
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0

func hitstop_small() -> void:
	hitstop(0.08, 0.15)

func hitstop_medium() -> void:
	hitstop(0.2, 0.05)

func hitstop_large() -> void:
	hitstop(0.1, 0.0)
