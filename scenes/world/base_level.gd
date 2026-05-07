class_name Level
extends Node2D

enum WinCondition {
	KILL_ALL_ENEMIES,
}

@export_category("Identity")
@export var level_id: String = ""

@export_category("Win Condition")
@export var win_condition: WinCondition = WinCondition.KILL_ALL_ENEMIES

# Required child nodes - every level scene must have it
@onready var enemies_container: Node2D = $Enemies
@onready var finish_line: Area2D = $FinishLine
@onready var finish_sprite: Sprite2D = $FinishLine/Sprite2D

signal enemies_remaining_changed(count: int)
signal level_completed
signal level_started

var is_complete_unlocked: bool = false
var time_elapsed: float = 0.0
var is_timer_running: bool = false

func _ready() -> void:
	if level_id == "":
		push_warning("Level has no level_id set in inspector")
	
	enemies_container.child_exiting_tree.connect(_on_enemy_exiting)
	finish_line.body_entered.connect(_on_finish_line_entered)
	
	call_deferred("_start_level")

func _start_level() -> void:
	await  get_tree().process_frame
	
	# emit initial enemy count
	var initial_count: int = enemies_container.get_child_count()
	enemies_remaining_changed.emit(initial_count)
	
	# check if level is already winnable
	_check_win_condition(initial_count)
	
	is_timer_running = true
	level_started.emit()

func _process(delta: float) -> void:
	if is_timer_running:
		time_elapsed += delta

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
		level_completed.emit(time_elapsed)
