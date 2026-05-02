extends Node2D

@export var weapon_data: WeaponData

@onready var muzzle : Marker2D = $Muzzle
@onready var player : Player = get_parent()

signal empowerment_cleared

var pending_empowerment: CardData = null
var _cooldown_timer: float = 0.0

func _ready() -> void:
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
	
	if pending_empowerment != null and pending_empowerment.empowered_projectile_scene != null:
		scene = pending_empowerment.empowered_projectile_scene
	else:
		scene = weapon_data.projectile_scene
	
	
	var projectile : Projectile = scene.instantiate()
	
	projectile.global_position = muzzle.global_position
	
	projectile.max_distance = weapon_data.weapon_range
	
	projectile.velocity = player.aim_direction * weapon_data.projectile_speed
	
	# set projectile as a child of "Projectiles" node in the level
	var main : Main = Main.get_instance(get_tree())
	var container : Node2D = main.game_manager.get_projectiles_container()
	if container:
		container.add_child(projectile)
	
	if pending_empowerment:
		pending_empowerment = null
		empowerment_cleared.emit()

func _on_card_sacrificed(card: CardData) -> void:
	pending_empowerment = card
