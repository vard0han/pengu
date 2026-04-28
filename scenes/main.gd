class_name Main
extends Node2D

@onready var player: Player = $Player
@onready var current_level: Node2D = $CurrentLevel
@onready var hud: CanvasLayer = $HUD
@onready var game_manager: Node = $GameManager

static func get_instance(tree: SceneTree) -> Main:
	return tree.current_scene as Main
