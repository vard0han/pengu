class_name DashState
extends PlayerState

var _dash_timer: float = 0.0
const DASH_DURATION: float = 0.15
const DASH_SPEED: float = 300.0

const DASH_TRAIL_SCENE: PackedScene = preload("res://scenes/effects/particles/dash_trail.tscn")

func enter() -> void:
	super()
	
	player.velocity.y = 0.0
	player.velocity.x = DASH_SPEED * player.last_direction
	_dash_timer = DASH_DURATION
	
	player.anim_player.play("run")
	
	AudioManager.play_sfx("air_whoosh", 25.0, randf_range(0.65, 0.8))
	
	player.shake_camera("small")
	_spawn_trail()

func _spawn_trail() -> void:
	var main: Main = Main.get_instance(player.get_tree())
	if main == null:
		return
	
	var trail: DashTrailEffectParticle = main.game_manager.spawn_particle(DASH_TRAIL_SCENE, player.global_position)
	if trail == null:
		return
	
	trail.start(player.last_direction)

func process_physics(delta: float) -> void:
	if not player: return
	
	# -------------STATE LOGIC-------------
	
	_dash_timer -= delta
	
	# -------------TRANSITION LOGIC-------------
	
	if _dash_timer <= 0:
		_state_machine.transition_to("Fall")
		return
