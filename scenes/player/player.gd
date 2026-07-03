class_name Player
extends CharacterBody2D

@export_category("Horizontal Movement")
@export var move_speed : float = 105.0
@export var acceleration : float = 1000.0
@export var deceleration : float = 800.0

@export_category("Jump — Designer Inputs")
## How high the jump reaches, measured in tiles.
@export var jump_height_tiles: float = 4.0
## Seconds to reach the top of the jump. Lower = snappier rise.
@export var time_to_apex: float = 0.38
## Seconds to fall back the same height. Lower than time_to_apex = faster fall.
#@export var time_to_fall: float = 0.28
## fall multiplier for gravity. so that fall is quicker than jump
@export var fall_gravity_multiplier: float = 2.0
## Size of one tile in pixels. Jump height is measured in these.
@export var tile_size: float = 18.0

@export_category("Jump — Feel Knobs")
## Velocity.y window (pixels/sec) around zero that counts as "at apex".
@export var apex_threshold: float = 40.0
## Gravity multiplier inside the apex window. Below 1.0 = hangtime.
@export var apex_gravity_multiplier: float = 0.5
## When jump is released early while rising, velocity.y is multiplied by this.
@export var jump_cut_multiplier: float = 0.4
## Maximum downward speed, pixels/sec. Caps terminal velocity.
@export var max_fall_speed: float = 600.0

@export_category("Advanced Movement")
@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.1

var aim_direction: Vector2 = Vector2.RIGHT
var direction : float = 1.0
var last_direction : float = 1.0

var rise_gravity: float = 0.0
var fall_gravity: float = 0.0
var jump_velocity: float = 0.0

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

# flicker for iframes (after damaged)
const FLICKED_FREQUENCY: float = 10.0
var _flicker_timer: float = 0.0

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var card_inventory: CardInventory = $CardInventory
@onready var state_machine: StateMachine = $StateMachine
@onready var weapon: Node2D = $Weapon
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var camera: PlayerCamera = $Camera2D

signal died

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	health_component.died.connect(_on_died)
	health_component.damaged.connect(_on_damaged)
	_recalculate_jump()

func _physics_process(delta: float) -> void:
	coyote_timer = maxf(coyote_timer - delta, 0.0)
	jump_buffer_timer = maxf(jump_buffer_timer - delta, 0.0)

func _process(delta: float) -> void:
	aim_direction = (get_global_mouse_position() - global_position).normalized()
	
	# flip the sprite according to aim
	sprite.flip_h = aim_direction.x < 0
	
	# get player direction for everything
	direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		last_direction = direction
	
	_update_invincibility_flicker(delta)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	
	if event.is_action_pressed("use_card"):
		_try_use_card()
	
	if event.is_action_pressed("sacrifice_card"):
		_try_sacrifice_card()
	
	if event.is_action_pressed("cycle_card"):
		_try_cycle_card()

func _recalculate_jump() -> void:
	var height_px: float = jump_height_tiles * tile_size
	rise_gravity = (2.0 * height_px) / (time_to_apex * time_to_apex)
	#fall_gravity = (2.0 * height_px) / (time_to_fall * time_to_fall)
	fall_gravity = rise_gravity * fall_gravity_multiplier
	jump_velocity = rise_gravity * time_to_apex

func _on_died() -> void:
	AudioManager.stop_music(0.2)
	AudioManager.play_sfx("player_death", -15.0, randf_range(0.5, 0.7))
	
	died.emit()

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

func _on_damaged(_amount: int) -> void:
	shake_camera("medium")
	TimeManager.hitstop_small()
	
	_flicker_timer = health_component.damage_cooldown

func _update_invincibility_flicker(delta: float) -> void:
	if _flicker_timer > 0.0:
		_flicker_timer = maxf(_flicker_timer - delta, 0.0)
		
		# alternate between visible and dimmed (FLICKER_FREQUENCY hz)
		var phase: float = fmod(_flicker_timer * FLICKED_FREQUENCY, 1.0)
		sprite.modulate.a = 0.4 if phase < 0.5 else 1.0
		
		if _flicker_timer <= 0.0:
			sprite.modulate.a = 1.0
	else:
		sprite.modulate.a = 1.0

func shake_camera(strength: String) -> void:
	match strength:
		"small": camera.shake_small()
		"medium": camera.shake_medium()
		"large": camera.shake_large()
