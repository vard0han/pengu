class_name GameManager
extends Node

@onready var main: Main = get_parent()

var current_level_instance: Node2D = null

func _ready() -> void:
	call_deferred("load_level", "res://scenes/levels/placeholder_level.tscn")

func load_level(path: String) -> void:
	# free existing level
	if current_level_instance:
		current_level_instance.queue_free()
		current_level_instance = null
	
	# instance new level
	var level_scene: PackedScene = load(path)
	if not level_scene:
		push_error("Failed to load level: " + path)
		return
	
	current_level_instance = level_scene.instantiate()
	main.current_level.add_child(current_level_instance)
	
	var spawn_marker: Marker2D = current_level_instance.get_node_or_null("PlayerSpawn")
	
	if spawn_marker:
		main.player.global_position = spawn_marker.global_position
	else:
		push_warning("Level has no PlayerSpawn market - player position unchanged")

func get_projectiles_container() -> Node:
	if current_level_instance:
		return current_level_instance.get_node_or_null("Projectiles")
	return null

func get_pickups_container() -> Node:
	if current_level_instance:
		return current_level_instance.get_node_or_null("Pickups")
	return null
