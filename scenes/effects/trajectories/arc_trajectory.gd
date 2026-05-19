class_name ArcTrajectory
extends TrajectoryBase

const TRAJECTORY_STEPS: int = 30
const STEP_TIME: float = 0.05
const GRAVITY: float = 600.0
const MIN_LIFT: float = 0.0

func _compute_points(from: Vector2, _aim_direction: Vector2, aim_target: Vector2) -> Array[Vector2]:
	var points: Array[Vector2] = []
	
	# Compute the initial velocity needed to reach aim_target from from
	# using the same ballistic math ArcProjectile uses when fired
	var dx: float = aim_target.x - from.x
	var dy: float = aim_target.y - from.y
	var rise: float = max(-dy, MIN_LIFT)
	var vy: float = -sqrt(2.0 * GRAVITY * rise)
	var t_total: float = -vy / GRAVITY
	var vx: float = dx / t_total
	var velocity : Vector2 = Vector2(vx, vy)
	
	var space_state : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var last_point: Vector2 = from
	
	for i : int in range(1, TRAJECTORY_STEPS):
		var t: float = i * STEP_TIME
		var pos: Vector2 = from + velocity * t + Vector2(0, 0.5 * GRAVITY * t * t)
		
		# Stop trajectory at world geometry
		var query : PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(last_point, pos)
		query.collision_mask = 1  # World layer
		var result : Dictionary = space_state.intersect_ray(query)
		if result:
			points.append(result.position)
			break
		
		points.append(pos)
		last_point = pos
	
	return points


#[Cards] Add trajectory preview system with scene-based architecture
#
#- TrajectoryBase scene with shared _draw rendering (dots with black outline)
#- ArcTrajectory inherited scene — ballistic math + raycast wall termination
#- PierceTrajectory inherited scene — straight line, ignores walls
#- trajectory_scene export on CardData (null = no preview)
#- jump_card.tres → arc_trajectory.tscn
#- dash_card.tres → pierce_trajectory.tscn
#- Weapon instances trajectory scene lazily on empowerment activation
#- Weapon frees trajectory on empowerment consumed, cancelled, or null
#- Trajectory cleared explicitly at shot fire moment (no one-frame ghost)
#- class_names on subclasses for Remote tab debuggability
