class_name LevelResults
extends Control

@onready var time_label: Label = %TimeLabel
@onready var best_label: Label = %BestLabel
@onready var medal_label: Label = %MedalLabel
@onready var best_medal_label: Label = %BestMedalLabel
@onready var gold_row: Label = %GoldRow
@onready var silver_row: Label = %SilverRow
@onready var bronze_row: Label = %BronzeRow
@onready var continue_button: Button = %ContinueButton

const COLOR_GOLD: Color = Color(1.0, 0.85, 0.3)
const COLOR_SILVER: Color = Color(0.75, 0.75, 0.75)
const COLOR_BRONZE: Color = Color(0.8, 0.5, 0.2)
const COLOR_NONE: Color = Color(0.4, 0.4, 0.4)
const COLOR_EARNED: Color = Color.WHITE

signal continue_pressed

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	continue_button.pressed.connect(func() -> void: continue_pressed.emit())

func setup(
	level_time: float, 
	best_time: float, 
	is_new_best_time: bool,
	earned_medal: Level.Medal,
	best_medal: Level.Medal,
	is_new_best_medal: bool,
	gold: float,
	silver: float,
	bronze: float) -> void:
	_set_time_labels(level_time, best_time, is_new_best_time)
	_set_medal_labels(earned_medal, best_medal, is_new_best_medal)
	_set_threshold_rows(gold, silver, bronze)

func _set_time_labels(level_time: float, best_time: float, is_new_best: bool) -> void:
	time_label.text = "TIME: %.2f" % level_time
	
	if is_new_best:
		best_label.text = "NEW BEST!"
		best_label.modulate = COLOR_GOLD
	else:
		best_label.text = "BEST: %.2f" % best_time
		best_label.modulate = COLOR_EARNED

func _set_medal_labels(earned: Level.Medal, best: Level.Medal, is_new_best: bool) -> void:
	medal_label.text = _medal_name(earned)
	medal_label.modulate = _medal_color(earned)
	
	if is_new_best and earned != Level.Medal.NONE:
		best_medal_label.text = "NEW BEST MEDAL!"
		best_medal_label.modulate = COLOR_GOLD
	elif best == Level.Medal.NONE:
		best_medal_label.text = ""
	else:
		best_medal_label.text = "BEST MEDAL: " + _medal_name(best)
		best_medal_label.modulate = COLOR_EARNED

func _set_threshold_rows(gold: float, silver: float, bronze: float) -> void:
	gold_row.text =   "GOLD:     %.2f" % gold
	silver_row.text = "SILVER:   %.2f" % silver
	bronze_row.text = "BRONZE:   %.2f" % bronze
	
	gold_row.modulate = COLOR_GOLD 
	silver_row.modulate = COLOR_SILVER
	bronze_row.modulate = COLOR_BRONZE 

func _medal_name(medal: Level.Medal) -> String:
	match medal:
		Level.Medal.GOLD: return "GOLD"
		Level.Medal.SILVER: return "SILVER"
		Level.Medal.BRONZE: return "BRONZE"
		_: return "NO MEDAL"

func _medal_color(medal: Level.Medal) -> Color:
	match medal:
		Level.Medal.GOLD: return COLOR_GOLD
		Level.Medal.SILVER: return COLOR_SILVER
		Level.Medal.BRONZE: return COLOR_BRONZE
		_: return COLOR_NONE
