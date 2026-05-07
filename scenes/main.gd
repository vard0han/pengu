class_name Main
extends Node2D

@onready var player: Player = $Player
@onready var current_level: Node2D = $CurrentLevel
@onready var hud_layer: CanvasLayer = $HUD
@onready var game_manager: GameManager = $GameManager

var hud: HUD = null
var results_instance: LevelResults = null

func _ready() -> void:
	var hud_scene: PackedScene = load("res://scenes/ui/hud.tscn")
	hud = hud_scene.instantiate()
	hud_layer.add_child(hud)
	
	game_manager.level_loaded.connect(_on_level_loaded)
	call_deferred("_connect_hud_signals")

func _on_level_loaded() -> void:
	var level: Level = game_manager.current_level_instance as Level
	if level == null:
		push_warning("Loaded scene is not a Level - skipping wiring")
		return
	
	level.enemies_remaining_changed.connect(_on_enemies_remaining_changed)
	level.level_completed.connect(_on_level_completed)
	
	# set active level on hud so it can read the timer
	hud.set_active_level(level)

func _on_enemies_remaining_changed(count: int) -> void:
	hud.update_enemies_remaining(count)

func _on_level_completed(time: float) -> void:
	var level: Level = game_manager.current_level_instance as Level
	var level_id: String = level.level_id
	
	var previous_best: float = BestTimes.get_best_time(level_id)
	var is_new_best: bool = BestTimes.record_time(level_id, time)
	
	_show_results(time, previous_best, is_new_best)

func _show_results(time: float, previous_best: float, is_new_best: bool) -> void:
	var scene: PackedScene = load("res://scenes/ui/level_results.tscn")
	results_instance = scene.instantiate()
	hud_layer.add_child(results_instance)
	
	var displayed_best: float = previous_best
	if previous_best == INF or is_new_best:
		displayed_best = time
	
	results_instance.setup(time, displayed_best, is_new_best)
	results_instance.continue_pressed.connect(_on_results_continue)

func _on_results_continue() -> void:
	if results_instance:
		results_instance.queue_free()
		results_instance = null
	
	game_manager.show_weapon_select(game_manager.pending_level_path)

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
