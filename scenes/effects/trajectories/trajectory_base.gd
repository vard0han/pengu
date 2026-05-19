class_name TrajectoryBase
extends Node2D

const DOT_RADIUS: float = 1.5
const OUTLINE_RADIUS: float = 0.5

var _points: Array[Vector2] = []
var _color: Color = Color.WHITE

var max_range: float = 1000.0

@export var dot_texture: Texture2D

func update_trajectory(from: Vector2, aim_direction: Vector2, aim_target: Vector2, color: Color) -> void:
	_color = color
	_points = _compute_points(from, aim_direction, aim_target)
	queue_redraw()

func clear() -> void:
	_points = []
	queue_redraw()

func _compute_points(_from: Vector2, _aim_direction: Vector2, _aim_target: Vector2) -> Array[Vector2]:
	return []

func _draw() -> void:
	if dot_texture == null:
		return
	
	var size: Vector2 = dot_texture.get_size()
	var half_size: Vector2 = size / 2.0
	
	for point: Vector2 in _points:
		var local: Vector2 = to_local(point)
		draw_texture(dot_texture, local - half_size, _color)
