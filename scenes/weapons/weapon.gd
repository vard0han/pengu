class_name Weapon
extends Node2D

@export var weapon_data: WeaponData

@onready var player : Player = get_parent()

signal empowerment_cleared

var pending_empowerment: CardData = null
var _cooldown_timer: float = 0.0
var _current_visual: Node2D = null
var _muzzle: Marker2D = null

func _ready() -> void:
	_instance_visual()
	call_deferred("_connect_signals")

func _connect_signals() -> void:
	player.card_inventory.card_sacrificed.connect(_on_card_sacrificed)

func _process(delta: float) -> void:
	if not player: return
	
	rotation = player.aim_direction.angle()
	
	_cooldown_timer = maxf(_cooldown_timer - delta, 0.0)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		_try_attack()

func _try_attack() -> void:
	if weapon_data == null:
		push_warning("Weapon has no weapon_data assigned")
		return
	
	if _cooldown_timer > 0.0 and pending_empowerment == null:
		return
	
	spawn_projectile()
	_cooldown_timer = 1.0 / weapon_data.fire_rate

func spawn_projectile() -> void:
	var scene : PackedScene
	var is_empowered: bool = false
	
	if pending_empowerment != null and pending_empowerment.empowered_projectile_scene != null:
		scene = pending_empowerment.empowered_projectile_scene
		is_empowered = true
	else:
		scene = weapon_data.projectile_scene
	
	var projectile : Projectile = scene.instantiate()
	
	projectile.global_position = _muzzle.global_position
	projectile.max_distance = weapon_data.weapon_range
	projectile.velocity = player.aim_direction * weapon_data.projectile_speed
	
	var sprite: Sprite2D = projectile.get_node_or_null("Sprite2D")
	if sprite and weapon_data.projectile_texture:
		sprite.texture = weapon_data.projectile_texture
	
	if is_empowered:
		if sprite:
			sprite.modulate = pending_empowerment.color
		pending_empowerment = null
		empowerment_cleared.emit()
		_clear_empowerment_visual()
	
	# set projectile as a child of "Projectiles" node in the level
	var main : Main = Main.get_instance(get_tree())
	var container : Node2D = main.game_manager.get_projectiles_container()
	if container:
		container.add_child(projectile)

func _on_card_sacrificed(card: CardData) -> void:
	pending_empowerment = card
	_apply_empowerment_visual(card)

func _apply_empowerment_visual(card: CardData) -> void:
	if _current_visual == null:
		return
	
	var sprite: Sprite2D = _current_visual.get_node("%Sprite2D")
	if sprite:
		sprite.modulate = card.color

func _clear_empowerment_visual() -> void:
	if _current_visual == null:
		return
	
	var sprite: Sprite2D = _current_visual.get_node("%Sprite2D")
	if sprite:
		sprite.modulate = Color.WHITE

func _instance_visual() -> void:
	if _current_visual:
		_current_visual.queue_free()
		_current_visual = null
		_muzzle = null
	
	if weapon_data == null or weapon_data.visual_scene == null:
		push_warning("Weapon has no visual_scene")
		return
	
	_current_visual = weapon_data.visual_scene.instantiate()
	add_child(_current_visual)
	
	# get the muzzle reference
	_muzzle = _current_visual.get_node("%Muzzle")
	if not _muzzle:
		push_warning("Weapon visual has no muzzle node marked as unique")

func set_weapon(new_weapon_data: WeaponData) -> void:
	weapon_data = new_weapon_data
	_instance_visual()
