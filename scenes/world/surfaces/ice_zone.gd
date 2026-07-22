@tool
class_name IceZone
extends Area2D

@export var length_tiles: int = 4:
	set(value):
		length_tiles = maxi(value, 1)
		if is_node_ready():
			_rebuild()

@export var top_margin: float = 4.0

const TILE_SIZE: float = 18.0
@onready var _sprite: Sprite2D = $Sprite2D
@onready var _collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_rebuild()

func _rebuild() -> void:
	if _sprite == null or _collision == null:
		return
	var width_px: float = length_tiles * TILE_SIZE

	_sprite.region_enabled = true
	_sprite.region_rect = Rect2(0, 0, width_px, TILE_SIZE)
	_sprite.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	_sprite.position = Vector2.ZERO

	var shape: RectangleShape2D = _collision.shape as RectangleShape2D
	if shape == null:
		shape = RectangleShape2D.new()
		_collision.shape = shape

	var total_height: float = TILE_SIZE + top_margin
	shape.size = Vector2(width_px, total_height)
	# Shift the shape's center up by half the margin so the extra height
	# extends upward from the sprite's top edge, not downward into the floor.
	_collision.position = Vector2(0, -top_margin / 2.0)

func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.enter_surface_zone(Player.SurfaceType.ICE)

func _on_body_exited(body: Node) -> void:
	if body is Player:
		body.exit_surface_zone(Player.SurfaceType.ICE)
