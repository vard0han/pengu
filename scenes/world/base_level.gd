class_name Level
extends Node2D

enum WinCondition {
	KILL_ALL_ENEMIES,
}

enum Medal {
	NONE, 
	BRONZE,
	SILVER,
	GOLD,
	DEV
}

@export_category("Identity")
@export var level_id: String = ""
@export var display_name: String = ""

@export_category("Medal Thresholds")
@export var gold_time: float = 0.0
@export var silver_time: float = 0.0
@export var bronze_time: float = 0.0
@export var dev_time: float = 0.0

@export_category("Win Condition")
@export var win_condition: WinCondition = WinCondition.KILL_ALL_ENEMIES

# Required child nodes - every level scene must have it
@onready var enemies_container: Node2D = $Enemies
@onready var finish_line: Area2D = $FinishLine
@onready var finish_sprite: Sprite2D = $FinishLine/Sprite2D
@onready var kill_zone: Area2D = $KillZone

signal enemies_remaining_changed(count: int)
signal level_completed
signal level_started

signal restart_requested
signal restart_with_weapon_requested

const RESTART_HOLD_DURATION: float = 0.5

var is_complete_unlocked: bool = false
var time_elapsed: float = 0.0
var is_timer_running: bool = false
var _timer_armed: bool = false

func _ready() -> void:
	if level_id == "":
		push_warning("Level has no level_id set in inspector")
	
	enemies_container.child_exiting_tree.connect(_on_enemy_exiting)
	finish_line.body_entered.connect(_on_finish_line_entered)
	kill_zone.body_entered.connect(_on_kill_zone_entered)
	
	call_deferred("_start_level")

func _on_kill_zone_entered(body: Node) -> void:
	if body is Player:
		body.health_component.take_damage_ignore_cooldown(999)

func _start_level() -> void:
	await  get_tree().process_frame
	
	AudioManager.play_music("tengo_ost", 0.5)
	
	_freeze_enemies()
	
	# emit initial enemy count
	var initial_count: int = enemies_container.get_child_count()
	enemies_remaining_changed.emit(initial_count)
	
	# check if level is already winnable
	_check_win_condition(initial_count)
	
	_show_title_card()
	
	_timer_armed = true
	level_started.emit()

func _process(delta: float) -> void:
	if is_timer_running:
		time_elapsed += delta
	elif _timer_armed:
		if _player_provided_input():
			_timer_armed = false
			is_timer_running = true
			_unfreeze_enemies()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart_level"):
		restart_requested.emit()
	
	if event.is_action_pressed("restart_with_weapon"):
		restart_with_weapon_requested.emit()

func _player_provided_input() -> bool:
	return (
		Input.is_action_pressed("move_left") or
		Input.is_action_pressed("move_right") or
		Input.is_action_pressed("jump") or
		Input.is_action_pressed("attack")
	)

# called when enemy is removed from the tree
func _on_enemy_exiting(_child: Node) -> void:
	var remaining: int = enemies_container.get_child_count() - 1
	enemies_remaining_changed.emit(remaining)
	_check_win_condition(remaining)

func _check_win_condition(enemies_remaining: int) -> void:
	if is_complete_unlocked:
		return
	
	var condition_met: bool = false
	
	match win_condition:
		WinCondition.KILL_ALL_ENEMIES:
			condition_met = (enemies_remaining <= 0)
	
	if condition_met:
		is_complete_unlocked = true
		finish_sprite.modulate = Color.WHITE
		print("Level: finish line unlocked")

func _on_finish_line_entered(body: Node) -> void:
	if not is_complete_unlocked:
		return
	if body is Player:
		is_timer_running = false
		
		AudioManager.stop_music(0.5)
		AudioManager.play_sfx("level_complete", -15.0, 0.95)
		
		level_completed.emit(time_elapsed)

func get_medal_for_time(time: float) -> Medal:
	if time <= dev_time:
		return Medal.DEV
	if time <= gold_time:
		return Medal.GOLD
	if time <= silver_time:
		return Medal.SILVER
	if time <= bronze_time:
		return Medal.BRONZE
	
	return Medal.NONE

func _show_title_card() -> void:
	var card_scene: PackedScene = preload("res://scenes/ui/level_title_card.tscn")
	var card: LevelTitleCard = card_scene.instantiate()
	
	var main: Main = Main.get_instance(get_tree())
	if main:
		main.hud_layer.add_child(card)
		card.show_title(display_name.to_upper(), 2.0)

func _freeze_enemies() -> void:
	for enemy: Enemy in enemies_container.get_children():
		enemy.process_mode = Node.PROCESS_MODE_DISABLED

func _unfreeze_enemies() -> void:
	for enemy: Enemy in enemies_container.get_children():
		enemy.process_mode = Node.PROCESS_MODE_INHERIT
