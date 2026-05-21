class_name CardData
extends Resource

@export_category("Identity")
@export var card_name: String = ""
@export var card_id: String = ""

@export_category("Display")
@export var display_label: String = "?"
@export var color: Color = Color.GRAY
@export var icon: Texture2D

@export_category("Behavior")
@export var movement_ability_scene: PackedScene
@export var empowered_projectile_scene: PackedScene
@export var trajectory_scene: PackedScene
