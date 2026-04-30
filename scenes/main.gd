class_name Main
extends Node2D

@onready var player: Player = $Player
@onready var current_level: Node2D = $CurrentLevel
@onready var hud_layer: CanvasLayer = $HUD
@onready var game_manager: Node = $GameManager

var hud: HUD = null

func _ready() -> void:
	var hud_scene: PackedScene = load("res://scenes/ui/hud.tscn")
	hud = hud_scene.instantiate()
	hud_layer.add_child(hud)
	
	call_deferred("_connect_hud_signals")

func _connect_hud_signals() -> void:
	var inventory: CardInventory = player.card_inventory
	
	inventory.card_added.connect(_refresh_hud_inventory)
	inventory.card_removed.connect(_refresh_hud_inventory)
	inventory.card_cycled.connect(_refresh_hud_inventory)
	
	inventory.card_sacrificed.connect(_on_card_sacrificed)
	
	player.weapon.empowerment_cleared.connect(_on_empowerment_cleared)
	
	hud.refresh_inventory(inventory.cards)

func _refresh_hud_inventory(_card: CardData = null, _slot_index: int = 0) -> void:
	hud.refresh_inventory(player.card_inventory.cards)

func _on_card_sacrificed(card: CardData) -> void:
	hud.set_empowered(true, card)

func _on_empowerment_cleared() -> void:
	hud.set_empowered(false)

static func get_instance(tree: SceneTree) -> Main:
	return tree.current_scene as Main
