class_name Projectile
extends Area2D

@export var lifetime: float = 5.0
@export var impact_scene: PackedScene

var max_distance: float = 1000.0
var velocity: Vector2 = Vector2.ZERO
var _distance_travelled: float = 0.0 # range checks against this

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func on_launched() -> void:
	pass

func _on_body_entered(_body: Node) -> void:
	AudioManager.play_sfx("enemy_hit", -20.0, randf_range(2.0, 2.2))
	die()

func _physics_process(delta: float) -> void:
	var step: Vector2 = velocity * delta
	global_position += step
	_distance_travelled += step.length()
	
	if _distance_travelled >= max_distance:
		_vanish()
		return
	
	_tick_lifetime(delta)

func _tick_lifetime(delta: float) -> void:
	lifetime -= delta
	
	if lifetime <= 0:
		_vanish()

func _spawn_impact() -> void:
	if impact_scene == null:
		return
	
	var main : Main = Main.get_instance(get_tree())
	if main:
		main.game_manager.spawn_particle(impact_scene, global_position, modulate, velocity.angle() + PI)

func die() -> void:
	_spawn_impact()
	_vanish()

func _vanish() -> void:
	set_physics_process(false)
	set_deferred("monitoring", false)
	if has_node("Hitbox"):
		get_node("Hitbox").set_deferred("monitoring", false)
	var tween : Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.15)
	tween.tween_property(self, "modulate:a", 0.0, 0.15)
	tween.chain().tween_callback(queue_free)
