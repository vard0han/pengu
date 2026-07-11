class_name Main
extends Node2D

@onready var current_level: Node2D = $CurrentLevel
@onready var hud_layer: CanvasLayer = $HUD
@onready var game_manager: GameManager = $GameManager

var hud: HUD = null
var results_instance: LevelResults = null
var game_over_instance: GameOver = null
var current_player: Player = null
var main_menu_instance: Control = null
var level_select_instance: Control = null
var pause_menu_instance: Control = null

func _ready() -> void:
	var hud_scene: PackedScene = load("res://scenes/ui/hud.tscn")
	hud = hud_scene.instantiate()
	hud_layer.add_child(hud)
	hud.visible = false
	
	game_manager.level_loaded.connect(_on_level_loaded)
	
	_instance_pause_menu()
	show_main_menu()

func _on_level_loaded() -> void:
	var level: Level = game_manager.current_level_instance as Level
	if level == null:
		push_warning("Loaded scene is not a Level - skipping wiring")
		return
	
	current_player = level.get_node_or_null("Player") as Player
	if current_player == null:
		push_warning("Level has no PLayer node")
		return
	
	if game_manager.selected_weapon:
		current_player.weapon.set_weapon(game_manager.selected_weapon)
	
	level.enemies_remaining_changed.connect(_on_enemies_remaining_changed)
	level.level_completed.connect(_on_level_completed)
	level.restart_requested.connect(_on_restart_requested)
	level.restart_with_weapon_requested.connect(_on_restart_with_weapon_requested)
	
	# set active level on hud so it can read the timer
	hud.set_active_level(level)
	
	_connect_player_signals()

func _on_restart_requested() -> void:
	_clear_death_ui()
	game_manager.load_level(game_manager.pending_level_path)

func _on_restart_with_weapon_requested() -> void:
	game_manager.show_weapon_select(game_manager.pending_level_path)

func _on_enemies_remaining_changed(count: int) -> void:
	hud.update_enemies_remaining(count)

func _on_level_completed(time: float) -> void:
	
	var level: Level = game_manager.current_level_instance as Level
	var level_id: String = level.level_id
	
	var previous_best_time: float = SaveData.get_best_time(level_id)
	var is_new_best_time: bool = SaveData.record_time(level_id, time)
	
	var earned_medal: Level.Medal = level.get_medal_for_time(time)
	var previous_best_medal: Level.Medal = SaveData.get_best_medal(level_id) as Level.Medal
	var is_new_best_medal: bool = SaveData.record_medal(level_id, earned_medal)
	
	_show_results(time, previous_best_time, is_new_best_time, earned_medal, previous_best_medal, is_new_best_medal, level)
	
	_free_current_level()

func _free_current_level() -> void:
	if game_manager.current_level_instance:
		game_manager.current_level_instance.queue_free()
		game_manager.current_level_instance = null
	current_player = null

func _show_results(
	time: float, 
	previous_best_time: float, 
	is_new_best_time: bool,
	earned_medal: Level.Medal,
	previous_best_medal: Level.Medal,
	is_new_best_medal: bool,
	level: Level
	) -> void:
	var scene: PackedScene = load("res://scenes/ui/level_results.tscn")
	results_instance = scene.instantiate()
	hud_layer.add_child(results_instance)
	
	var displayed_best_time: float = previous_best_time
	if previous_best_time == INF or is_new_best_time:
		displayed_best_time = time
	
	var displayed_best_medal: Level.Medal = previous_best_medal
	if is_new_best_medal:
		displayed_best_medal = earned_medal
	
	results_instance.setup(
		time, 
		displayed_best_time, 
		is_new_best_time,
		earned_medal,
		displayed_best_medal,
		is_new_best_medal,
		level.dev_time,
		level.gold_time,
		level.silver_time,
		level.bronze_time)
	results_instance.continue_pressed.connect(_on_results_continue)

func _on_results_continue() -> void:
	if results_instance:
		results_instance.queue_free()
		results_instance = null
	
	game_manager.show_weapon_select(game_manager.pending_level_path)

func _connect_player_signals() -> void:
	var inventory: CardInventory = current_player.card_inventory
	var player_health: HealthComponent = current_player.health_component
	
	inventory.card_added.connect(_refresh_hud_inventory)
	inventory.card_removed.connect(_refresh_hud_inventory)
	inventory.card_cycled.connect(_refresh_hud_inventory)
	
	hud.setup_player_hearts(player_health.max_health)
	hud.update_player_hearts(player_health.current_health)
	player_health.health_changed.connect(_on_player_health_changed)
	
	current_player.died.connect(_on_player_died)
	current_player.card_inventory.inventory_full.connect(_on_card_pickup_denied)
	
	hud.refresh_inventory(inventory.cards)

func _on_card_pickup_denied() -> void:
	AudioManager.play_sfx("player_hit", -15.0, randf_range(0.6, 0.8))
	hud.shake_inventory()

func _refresh_hud_inventory(_card: CardData = null, _slot_index: int = 0) -> void:
	hud.refresh_inventory(current_player.card_inventory.cards)

func _on_player_health_changed(current: int, _max: int) -> void:
	hud.update_player_hearts(current)

func _on_player_died() -> void:
	_free_current_level()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	var scene: PackedScene = load("res://scenes/ui/game_over.tscn")
	game_over_instance = scene.instantiate()
	hud_layer.add_child(game_over_instance)
	game_over_instance.retry_pressed.connect(_on_retry)

func _on_retry() -> void:
	_clear_death_ui()
	game_manager.reset_current_level()

static func get_instance(tree: SceneTree) -> Main:
	return tree.current_scene as Main

func show_main_menu() -> void:
	_free_current_menu()
	hud.visible = false
	
	var scene: PackedScene = load("res://scenes/ui/main_menu.tscn")
	main_menu_instance = scene.instantiate()
	hud_layer.add_child(main_menu_instance)

func show_level_select() -> void:
	_free_current_menu()
	hud.visible = false
	
	var scene: PackedScene = load("res://scenes/ui/level_select.tscn")
	level_select_instance = scene.instantiate()
	hud_layer.add_child(level_select_instance)

func start_level(path: String) -> void:
	_free_current_menu()
	hud.visible = true
	game_manager.show_weapon_select(path)

func return_to_main_menu() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	AudioManager.stop_music()
	if results_instance:
		results_instance.queue_free()
		results_instance = null
	if game_over_instance:
		game_over_instance.queue_free()
		game_over_instance = null
	_free_current_level()
	show_main_menu()
	AudioManager.stop_sfx_looped("footstep_grass")

func _free_current_menu() -> void:
	if main_menu_instance:
		main_menu_instance.queue_free()
		main_menu_instance = null
	if level_select_instance:
		level_select_instance.queue_free()
		level_select_instance = null

func _instance_pause_menu() -> void:
	var scene: PackedScene = load("res://scenes/ui/pause_menu.tscn")
	pause_menu_instance = scene.instantiate()
	hud_layer.add_child(pause_menu_instance)

func _clear_death_ui() -> void:
	if game_over_instance:
		game_over_instance.queue_free()
		game_over_instance = null
	if results_instance:
		results_instance.queue_free()
		results_instance = null
