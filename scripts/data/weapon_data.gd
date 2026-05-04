class_name WeaponData
extends Resource

@export_category("Identity")
@export var weapon_name: String = ""
@export var weapon_id: String = ""

@export_category("Behavior")
@export var projectile_scene: PackedScene
@export var fire_rate: float = 5.0
@export var weapon_range: float = 1000.0
@export var projectile_speed: float = 400.0

@export_category("Display")
@export var display_color: Color = Color.WHITE
@export var icon: Texture2D
@export var projectile_texture: Texture2D
@export var visual_scene: PackedScene
