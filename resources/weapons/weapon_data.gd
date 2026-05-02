class_name WeaponData
extends Resource

# Identity
@export var weapon_name: String = ""
@export var weapon_id: String = ""

# Behaviour
@export var projectile_scene: PackedScene
@export var fire_rate: float = 5.0 # shots per second
@export var weapon_range: float = 1000.0 # pixels travelled before despawn
@export var projectile_speed: float = 400.0

# Display (used by weapon select screen, HUD)
@export var display_color: Color = Color.WHITE
@export var icon: Texture2D
