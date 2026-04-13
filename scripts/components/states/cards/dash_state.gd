class_name DashState
extends PlayerState

var _dash_timer: float = 0.0
const DASH_DURATION: float = 0.2
const DASH_SPEED: float = 250.0

func enter() -> void:
	super()
	
	player.velocity.y = 0.0
	# TODO: fragile logic
	player.velocity.x = DASH_SPEED if player.sprite.flip_h else -DASH_SPEED
	_dash_timer = DASH_DURATION
	
	player.anim_player.play("run")

func process_physics(delta: float) -> void:
	if not player: return
	
	# -------------STATE LOGIC-------------
	
	_dash_timer -= delta
	
	# -------------TRANSITION LOGIC-------------
	
	if _dash_timer <= 0:
		_state_machine.transition_to("Fall")
		return
