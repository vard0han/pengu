class_name PauseMenu
extends Control

const COUNTDOWN_FROM: int = 2

@onready var _menu_panel: PanelContainer = $MenuPanel
@onready var _countdown: Label = $Countdown
@onready var _resume_button: Button = %ResumeButton
@onready var _main_menu_button: Button = %MainMenuButton
@onready var _weapon_select_button: Button = %WeaponSelectButton
@onready var _retry_button: Button = %RetryButton

var _is_resuming: bool = false

func _ready() -> void:
	visible = false
	_resume_button.pressed.connect(_on_resume_pressed)
	_main_menu_button.pressed.connect(_on_main_menu_pressed)
	_weapon_select_button.pressed.connect(_on_weapon_select_pressed)
	_retry_button.pressed.connect(_on_retry_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("pause"):
		return
	if not _is_in_level():
		return
	
	if get_tree().paused:
		if not _is_resuming:
			_on_resume_pressed()
	else:
		_open()

func _is_in_level() -> bool:
	var main : Main = Main.get_instance(get_tree())
	return main != null and main.game_manager.current_level_instance != null and main.game_manager.is_level_ready

func _open() -> void:
	get_parent().move_child(self, -1)
	visible = true
	_menu_panel.visible = true
	_countdown.visible = false
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _close() -> void:
	get_tree().paused = false
	visible = false
	_is_resuming = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_resume_pressed() -> void:
	if _is_resuming:
		return
	_is_resuming = true
	_menu_panel.visible = false
	await _play_countdown()
	_close()

func _on_main_menu_pressed() -> void:
	visible = false
	_is_resuming = false
	get_tree().paused = false
	Main.get_instance(get_tree()).return_to_main_menu()

func _on_weapon_select_pressed() -> void:
	visible = false
	_is_resuming = false
	get_tree().paused = false
	Main.get_instance(get_tree()).game_manager.reset_current_level_weapon()

func _play_countdown() -> void:
	_countdown.visible = true
	for i: int in range(COUNTDOWN_FROM, 0, -1):
		_countdown.text = str(i)
		_countdown.scale = Vector2.ONE
		_countdown.modulate.a = 1.0
		_countdown.pivot_offset = _countdown.size / 2.0

		var tween : Tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(_countdown, "scale", Vector2(0.3, 0.3), 1.0)
		tween.tween_property(_countdown, "modulate:a", 0.0, 1.0)
		await tween.finished

	_countdown.visible = false

func _on_retry_pressed() -> void:
	visible = false
	_is_resuming = false
	get_tree().paused = false
	Main.get_instance(get_tree()).game_manager.reset_current_level()
