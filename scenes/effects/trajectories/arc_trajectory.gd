class_name ArcTrajectory
extends TrajectoryBase

@export var gravity_strength: float = 600.0
@export var min_lift: float = 40.0

const TRAJECTORY_STEPS: int = 30
const STEP_TIME: float = 0.05

func _compute_points(from: Vector2, _aim_direction: Vector2, aim_target: Vector2) -> Array[Vector2]:
	var points: Array[Vector2] = []
	var velocity: Vector2 = ArcProjectile.compute_launch_velocity(from, aim_target, gravity_strength, min_lift)

	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var last_point: Vector2 = from

	for i: int in range(1, TRAJECTORY_STEPS):
		var t: float = i * STEP_TIME
		var pos: Vector2 = from + velocity * t + Vector2(0, 0.5 * gravity_strength * t * t)

		var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(last_point, pos)
		query.collision_mask = 1
		var result: Dictionary = space_state.intersect_ray(query)
		if result:
			points.append(result.position)
			break

		points.append(pos)
		last_point = pos

	return points
