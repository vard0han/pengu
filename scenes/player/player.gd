class_name Player
extends CharacterBody2D

@export_category("Horizontal Movement")
@export var move_speed : float = 100.0
@export var acceleration : float = 1000.0
@export var deceleration : float = 800.0

@export_category("Vertical Movement")
@export var jump_force : float = 300.0
@export var gravity : float = 800.0
@export var jump_cut_multiplier : float = 0.4
@export var max_fall_speed : float = 800.0

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.1

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D

@onready var card_inventory: CardInventory = $CardInventory

func _physics_process(delta: float) -> void:
	coyote_timer = maxf(coyote_timer - delta, 0.0)
	jump_buffer_timer = maxf(jump_buffer_timer - delta, 0.0)

func _unhandled_input(event) -> void:
	if event.is_action_pressed("jump"):
		jump_buffer_timer = jump_buffer_time

func collect_card(card: CardData) -> void:
	card_inventory.add_card(card)
