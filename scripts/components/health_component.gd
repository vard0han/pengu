class_name HealthComponent
extends Node

@export_category("Health")
@export var max_health: int = 3
@export var damage_cooldown: float = 0.0

var current_health: int = 0
var _cooldown_timer: float = 0.0

signal health_changed(current: int, max: int)
signal damaged(amount: int)
signal died

func _ready() -> void:
	current_health = max_health

func _process(delta: float) -> void:
	if _cooldown_timer > 0.0:
		_cooldown_timer = maxf(_cooldown_timer - delta, 0.0)

func take_damage(amount: int) -> void:
	if amount <= 0:
		return
	if _cooldown_timer > 0.0:
		return
	
	current_health = maxi(current_health - amount, 0)
	health_changed.emit(current_health, max_health)
	damaged.emit(amount)
	
	if damage_cooldown > 0.0:
		_cooldown_timer = damage_cooldown
	
	if current_health <= 0:
		died.emit()

func heal(amount: int) -> void:
	if amount <= 0:
		return
	
	current_health = mini(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)

func reset() -> void:
	current_health = max_health
	_cooldown_timer = 0.0
	health_changed.emit(current_health, max_health)

func is_alive() -> bool:
	return current_health > 0

func take_damage_ignore_cooldown(amount: int) -> void:
	if amount <= 0:
		return
	
	current_health = maxi(current_health - amount, 0)
	health_changed.emit(current_health, max_health)
	damaged.emit(amount)
	
	if current_health <= 0:
		died.emit()
