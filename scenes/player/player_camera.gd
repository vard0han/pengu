class_name PlayerCamera
extends Camera2D

const LOOK_AHEAD_DISTANCE: float = 60.0
const LOOK_AHEAD_LERP_SPEED: float = 1.5
const PLAYER_SCREEN_OFFSET: Vector2 = Vector2(0, -25)

var _shake_strength: float = 0.0
var _shake_duration: float = 0.0
var _shake_initial_duration: float = 0.0
var _shake_offset: Vector2 = Vector2.ZERO
var _look_ahead_offset: Vector2 = Vector2.ZERO

var _player: Player = null

func _ready() -> void:
	_player = get_parent() as Player

func _physics_process(delta: float) -> void:
	#_update_look_ahead(delta)
	_update_shake(delta)

	offset = (_look_ahead_offset + PLAYER_SCREEN_OFFSET + _shake_offset).round()

func _update_look_ahead(delta: float) -> void:
	if not _player:
		return

	var target_offset: Vector2 = Vector2.ZERO

	if _player.velocity.x > 50.0:
		target_offset.x = LOOK_AHEAD_DISTANCE
	elif _player.velocity.x < -50.0:
		target_offset.x = -LOOK_AHEAD_DISTANCE

	_look_ahead_offset = _look_ahead_offset.lerp(target_offset, LOOK_AHEAD_LERP_SPEED * delta)

func _update_shake(delta: float) -> void:
	if _shake_duration > 0.0:
		_shake_duration = maxf(_shake_duration - delta, 0.0)
		var current_strength: float = _shake_strength * (_shake_duration / _shake_initial_duration)
		_shake_offset = Vector2(randf_range(-current_strength, current_strength), randf_range(-current_strength, current_strength))
	else:
		_shake_offset = Vector2.ZERO

func shake(strength: float, duration: float) -> void:
	_shake_strength = strength
	_shake_duration = duration
	_shake_initial_duration = duration

func shake_small() -> void:
	shake(1.5, 0.15)

func shake_medium() -> void:
	shake(4.0, 0.25)

func shake_large() -> void:
	shake(8.0, 0.4)
