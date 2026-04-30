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

var aim_direction: Vector2 = Vector2.RIGHT
var direction : float = 1.0
var last_direction : float = 1.0

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.1

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D

@onready var card_inventory: CardInventory = $CardInventory

@onready var state_machine: StateMachine = $StateMachine

@onready var weapon: Node2D = $Weapon

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _physics_process(delta: float) -> void:
	coyote_timer = maxf(coyote_timer - delta, 0.0)
	jump_buffer_timer = maxf(jump_buffer_timer - delta, 0.0)

func _process(_delta: float) -> void:
	aim_direction = (get_global_mouse_position() - global_position).normalized()
	
	# flip the sprite according to aim
	sprite.flip_h = aim_direction.x > 0
	
	# get player direction for everything
	direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		last_direction = direction

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	
	if event.is_action_pressed("use_card"):
		_try_use_card()
	
	if event.is_action_pressed("sacrifice_card"):
		_try_sacrifice_card()
	
	if event.is_action_pressed("cycle_card"):
		_try_cycle_card()


func collect_card(card: CardData) -> void:
	card_inventory.add_card(card)

func _try_use_card() -> void:
	if card_inventory.cards.size() == 0: return
	
	var card: CardData  = card_inventory.use_card(0)
	
	if not card: return
	
	if not card.movement_ability_scene:
		print("Card has no movement_ability_scene assigned")
		return
	
	state_machine.transition_to_scene(card.movement_ability_scene)

func _try_sacrifice_card() -> void:
	if card_inventory.cards.size() == 0:
		return
	
	card_inventory.sacrifice_card(0)

func _try_cycle_card() -> void:
	if card_inventory.cards.size() > 1:
		card_inventory.cycle_card()
