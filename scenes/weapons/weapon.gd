extends Node2D

@export var projectile_scene: PackedScene

@onready var muzzle : Marker2D = $Muzzle
@onready var player : Player = get_parent()

signal empowerment_cleared

var pending_empowerment: CardData = null

func _ready() -> void:
	call_deferred("_connect_signals")

func _connect_signals() -> void:
	player.card_inventory.card_sacrificed.connect(_on_card_sacrificed)

func _process(_delta: float) -> void:
	if not player: return
	
	rotation = player.aim_direction.angle()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		spawn_projectile()

func spawn_projectile() -> void:
	var scene : PackedScene = pending_empowerment.empowered_projectile_scene if pending_empowerment else projectile_scene
	var projectile : Projectile = scene.instantiate()
	
	projectile.global_position = muzzle.global_position
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
