class_name CardData
extends Resource

@export var card_name : String = ""
# on the id lives the unique card name for matching to avoid typos
@export var card_id : String = ""
@export var movement_ability_scene : PackedScene = null
@export var empowered_projectile_scene: PackedScene
