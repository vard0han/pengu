class_name PierceTrajectory
extends TrajectoryBase

const TRAJECTORY_STEPS: int = 25
const DOT_SPACING: float = 20.0

func _compute_points(_from: Vector2, aim_direction: Vector2, _aim_target: Vector2) -> Array[Vector2]:
	var points: Array[Vector2] = []
	var distance: float = 0.0
	var i: int = 0
	
	while distance < max_range:
		if distance > 0:
			points.append(_from + aim_direction * distance)
		distance += DOT_SPACING
		i += 1
		if i > 100:
			break
	
	return points
