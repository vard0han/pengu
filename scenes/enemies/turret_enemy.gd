class_name TurretEnemy
extends Enemy

@export var fire_rate: float = 2.0
@export var bullet_speed: float = 200.0
@export var bullet_range: float = 400.0
@export var bullet_scene: PackedScene

@onready var _muzzle: Marker2D = $Muzzle
@onready var _fire_timer: Timer = $FireTimer
@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite = _animated_sprite
	super._ready()
	_fire_timer.wait_time = fire_rate
	_fire_timer.timeout.connect(_fire)
	_animated_sprite.animation_finished.connect(_on_shoot_finished)
	_animated_sprite.play("idle")
	
func _fire() -> void:
	if bullet_scene == null:
		push_warning("TurretEnemy: bullet_scene is not assigned.")
		return
	
	_animated_sprite.play("shoot")
	
	var bullet: TurretBullet = bullet_scene.instantiate()
	bullet.speed = bullet_speed
	bullet.max_distance = bullet_range
	
	var projectiles_container : Node2D = _get_projectiles_container()
	if projectiles_container == null:
		push_warning("TurretEnemy: could not find Projectiles container.")
		bullet.queue_free()
		return
	
	
	projectiles_container.add_child(bullet)
	bullet.global_position = _muzzle.global_position
	
	var direction : Vector2 = Vector2.RIGHT if scale.x > 0 else Vector2.LEFT
	bullet.launch(direction)


func _get_projectiles_container() -> Node:
	var main : Main = Main.get_instance(get_tree())
	if main and main.game_manager:
		return main.game_manager.get_projectiles_container()
	return null

func _on_shoot_finished() -> void:
	if _animated_sprite.animation == "shoot":
		_animated_sprite.play("idle")

func _apply_outline_color(color: Color) -> void:
	_animated_sprite.material.set_shader_parameter("outline_color", color)
