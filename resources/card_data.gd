class_name CardData
extends Resource

# Identity
@export var card_name : String = ""
# on the id lives the unique card name for matching to avoid typos
@export var card_id : String = ""

# Display
@export var display_label : String = "?"
@export var color : Color = Color.GRAY
@export var icon: Texture2D

# Behaviour
@export var movement_ability_scene : PackedScene = null
@export var empowered_projectile_scene: PackedScene
